# Health Check Automation

Script para executar health checks em múltiplos serviços e reportar status.

## 📋 Visão Geral

Este script automatiza verificações de saúde de serviços, incluindo:
- HTTP health checks
- Database connectivity
- Cache availability
- Message queue status
- Disk space
- SSL certificate expiration

## 🎯 Quando Usar

- Verificação periódica de saúde (via cron)
- Pre-deployment checks
- Post-deployment validation
- Incident triage
- Status page automation

## 📝 Script

### Bash Version

```bash
#!/bin/bash
# health-check.sh
# Executa health checks em serviços e reporta status
# Uso: ./health-check.sh [--json] [--slack-webhook URL]

set -euo pipefail

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuração
SERVICES_FILE="${SERVICES_FILE:-services.yaml}"
JSON_OUTPUT=false
SLACK_WEBHOOK=""
FAILED_CHECKS=0

# Parse argumentos
while [[ $# -gt 0 ]]; do
    case $1 in
        --json)
            JSON_OUTPUT=true
            shift
            ;;
        --slack-webhook)
            SLACK_WEBHOOK="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Funções de check

check_http() {
    local name=$1
    local url=$2
    local expected_code=${3:-200}
    
    local response_code=$(curl -s -o /dev/null -w "%{http_code}" "$url" 2>/dev/null || echo "000")
    
    if [[ "$response_code" == "$expected_code" ]]; then
        echo "✅ $name: HTTP $response_code"
        return 0
    else
        echo "❌ $name: HTTP $response_code (expected $expected_code)"
        ((FAILED_CHECKS++))
        return 1
    fi
}

check_tcp() {
    local name=$1
    local host=$2
    local port=$3
    
    if timeout 5 bash -c "cat < /dev/null > /dev/tcp/$host/$port" 2>/dev/null; then
        echo "✅ $name: TCP $host:$port reachable"
        return 0
    else
        echo "❌ $name: TCP $host:$port unreachable"
        ((FAILED_CHECKS++))
        return 1
    fi
}

check_database() {
    local name=$1
    local type=$2
    local connection_string=$3
    
    case $type in
        postgres)
            if psql "$connection_string" -c "SELECT 1" &>/dev/null; then
                echo "✅ $name: PostgreSQL connected"
                return 0
            fi
            ;;
        mysql)
            if mysql -e "SELECT 1" "$connection_string" &>/dev/null; then
                echo "✅ $name: MySQL connected"
                return 0
            fi
            ;;
        redis)
            if redis-cli -u "$connection_string" PING &>/dev/null; then
                echo "✅ $name: Redis responding"
                return 0
            fi
            ;;
    esac
    
    echo "❌ $name: $type connection failed"
    ((FAILED_CHECKS++))
    return 1
}

check_ssl_cert() {
    local name=$1
    local domain=$2
    local warn_days=${3:-30}
    
    local expiry=$(echo | openssl s_client -servername "$domain" -connect "$domain:443" 2>/dev/null | \
                   openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2)
    
    if [[ -z "$expiry" ]]; then
        echo "❌ $name: Cannot get SSL cert for $domain"
        ((FAILED_CHECKS++))
        return 1
    fi
    
    local expiry_epoch=$(date -d "$expiry" +%s)
    local now_epoch=$(date +%s)
    local days_left=$(( (expiry_epoch - now_epoch) / 86400 ))
    
    if [[ $days_left -lt $warn_days ]]; then
        echo "⚠️  $name: SSL cert expires in $days_left days"
        ((FAILED_CHECKS++))
        return 1
    else
        echo "✅ $name: SSL cert valid ($days_left days left)"
        return 0
    fi
}

check_disk_space() {
    local name=$1
    local path=$2
    local threshold=${3:-90}
    
    local usage=$(df -h "$path" | awk 'NR==2 {print $5}' | sed 's/%//')
    
    if [[ $usage -gt $threshold ]]; then
        echo "❌ $name: Disk usage ${usage}% > ${threshold}%"
        ((FAILED_CHECKS++))
        return 1
    else
        echo "✅ $name: Disk usage ${usage}%"
        return 0
    fi
}

# Executar checks
echo "🏥 Running Health Checks..."
echo "=========================="

# HTTP Checks
check_http "API Gateway" "https://api.example.com/health" 200
check_http "Web Frontend" "https://www.example.com" 200
check_http "Admin Panel" "https://admin.example.com/health" 200

# TCP Checks
check_tcp "PostgreSQL" "db.example.com" 5432
check_tcp "Redis" "redis.example.com" 6379
check_tcp "RabbitMQ" "rabbitmq.example.com" 5672

# Database Checks
check_database "Main DB" "postgres" "postgresql://user@db.example.com/maindb"
check_database "Cache" "redis" "redis://redis.example.com:6379"

# SSL Certificates
check_ssl_cert "API SSL" "api.example.com" 30
check_ssl_cert "Web SSL" "www.example.com" 30

# Disk Space
check_disk_space "App Server Disk" "/" 90
check_disk_space "Data Volume" "/data" 80

# Resultado
echo "=========================="
if [[ $FAILED_CHECKS -eq 0 ]]; then
    echo -e "${GREEN}✅ All checks passed!${NC}"
    exit 0
else
    echo -e "${RED}❌ $FAILED_CHECKS check(s) failed${NC}"
    
    # Notificar Slack se configurado
    if [[ -n "$SLACK_WEBHOOK" ]]; then
        curl -X POST "$SLACK_WEBHOOK" \
            -H 'Content-Type: application/json' \
            -d "{\"text\":\"⚠️ Health Check Failed: $FAILED_CHECKS checks failed\"}"
    fi
    
    exit 1
fi
```

### Python Version (Mais Completo)

```python
#!/usr/bin/env python3
"""
health_check.py - Comprehensive health check automation
"""

import argparse
import json
import sys
import time
from dataclasses import dataclass, asdict
from typing import List, Optional
import requests
import psycopg2
import redis
from datetime import datetime, timedelta
import ssl
import socket

@dataclass
class CheckResult:
    name: str
    status: str  # 'ok', 'warning', 'critical'
    message: str
    timestamp: str
    duration_ms: float

class HealthChecker:
    def __init__(self):
        self.results: List[CheckResult] = []
    
    def add_result(self, result: CheckResult):
        self.results.append(result)
    
    def check_http(self, name: str, url: str, 
                   expected_code: int = 200, 
                   timeout: int = 5) -> CheckResult:
        """Check HTTP endpoint"""
        start = time.time()
        try:
            response = requests.get(url, timeout=timeout)
            duration = (time.time() - start) * 1000
            
            if response.status_code == expected_code:
                return CheckResult(
                    name=name,
                    status='ok',
                    message=f'HTTP {response.status_code}',
                    timestamp=datetime.now().isoformat(),
                    duration_ms=duration
                )
            else:
                return CheckResult(
                    name=name,
                    status='critical',
                    message=f'HTTP {response.status_code} (expected {expected_code})',
                    timestamp=datetime.now().isoformat(),
                    duration_ms=duration
                )
        except Exception as e:
            duration = (time.time() - start) * 1000
            return CheckResult(
                name=name,
                status='critical',
                message=f'Error: {str(e)}',
                timestamp=datetime.now().isoformat(),
                duration_ms=duration
            )
    
    def check_postgres(self, name: str, connection_string: str) -> CheckResult:
        """Check PostgreSQL connection"""
        start = time.time()
        try:
            conn = psycopg2.connect(connection_string, connect_timeout=5)
            cursor = conn.cursor()
            cursor.execute("SELECT 1")
            cursor.close()
            conn.close()
            duration = (time.time() - start) * 1000
            
            return CheckResult(
                name=name,
                status='ok',
                message='PostgreSQL connected',
                timestamp=datetime.now().isoformat(),
                duration_ms=duration
            )
        except Exception as e:
            duration = (time.time() - start) * 1000
            return CheckResult(
                name=name,
                status='critical',
                message=f'Error: {str(e)}',
                timestamp=datetime.now().isoformat(),
                duration_ms=duration
            )
    
    def check_redis(self, name: str, host: str, port: int = 6379) -> CheckResult:
        """Check Redis connection"""
        start = time.time()
        try:
            r = redis.Redis(host=host, port=port, socket_timeout=5)
            r.ping()
            duration = (time.time() - start) * 1000
            
            return CheckResult(
                name=name,
                status='ok',
                message='Redis responding',
                timestamp=datetime.now().isoformat(),
                duration_ms=duration
            )
        except Exception as e:
            duration = (time.time() - start) * 1000
            return CheckResult(
                name=name,
                status='critical',
                message=f'Error: {str(e)}',
                timestamp=datetime.now().isoformat(),
                duration_ms=duration
            )
    
    def check_ssl_cert(self, name: str, hostname: str, 
                       warn_days: int = 30) -> CheckResult:
        """Check SSL certificate expiration"""
        start = time.time()
        try:
            context = ssl.create_default_context()
            with socket.create_connection((hostname, 443), timeout=5) as sock:
                with context.wrap_socket(sock, server_hostname=hostname) as ssock:
                    cert = ssock.getpeercert()
            
            expiry_date = datetime.strptime(
                cert['notAfter'], '%b %d %H:%M:%S %Y %Z'
            )
            days_left = (expiry_date - datetime.now()).days
            duration = (time.time() - start) * 1000
            
            if days_left < warn_days:
                status = 'warning' if days_left > 7 else 'critical'
                message = f'SSL cert expires in {days_left} days'
            else:
                status = 'ok'
                message = f'SSL cert valid ({days_left} days left)'
            
            return CheckResult(
                name=name,
                status=status,
                message=message,
                timestamp=datetime.now().isoformat(),
                duration_ms=duration
            )
        except Exception as e:
            duration = (time.time() - start) * 1000
            return CheckResult(
                name=name,
                status='critical',
                message=f'Error: {str(e)}',
                timestamp=datetime.now().isoformat(),
                duration_ms=duration
            )
    
    def run_all_checks(self):
        """Run all configured checks"""
        # HTTP checks
        self.add_result(
            self.check_http('API Gateway', 'https://api.example.com/health')
        )
        self.add_result(
            self.check_http('Web Frontend', 'https://www.example.com')
        )
        
        # Database checks
        self.add_result(
            self.check_postgres('Main DB', 'postgresql://user@db.example.com/db')
        )
        self.add_result(
            self.check_redis('Cache', 'redis.example.com')
        )
        
        # SSL checks
        self.add_result(
            self.check_ssl_cert('API SSL', 'api.example.com')
        )
    
    def print_results(self, json_output: bool = False):
        """Print results in human or JSON format"""
        if json_output:
            print(json.dumps([asdict(r) for r in self.results], indent=2))
        else:
            print("\n🏥 Health Check Results")
            print("=" * 50)
            
            for result in self.results:
                icon = {
                    'ok': '✅',
                    'warning': '⚠️ ',
                    'critical': '❌'
                }[result.status]
                
                print(f"{icon} {result.name}: {result.message} "
                      f"({result.duration_ms:.0f}ms)")
            
            print("=" * 50)
            
            failed = sum(1 for r in self.results if r.status != 'ok')
            if failed == 0:
                print("✅ All checks passed!")
            else:
                print(f"❌ {failed} check(s) failed")
    
    def get_exit_code(self) -> int:
        """Return exit code based on results"""
        if any(r.status == 'critical' for r in self.results):
            return 2
        if any(r.status == 'warning' for r in self.results):
            return 1
        return 0

def main():
    parser = argparse.ArgumentParser(description='Run health checks')
    parser.add_argument('--json', action='store_true', help='JSON output')
    parser.add_argument('--slack-webhook', help='Slack webhook URL for notifications')
    args = parser.parse_args()
    
    checker = HealthChecker()
    checker.run_all_checks()
    checker.print_results(json_output=args.json)
    
    # Send to Slack if configured and there are failures
    if args.slack_webhook and checker.get_exit_code() != 0:
        failed = sum(1 for r in checker.results if r.status != 'ok')
        requests.post(args.slack_webhook, json={
            'text': f'⚠️ Health Check Alert: {failed} checks failed'
        })
    
    sys.exit(checker.get_exit_code())

if __name__ == '__main__':
    main()
```

## 📋 Configuração

### services.yaml

```yaml
services:
  - name: API Gateway
    type: http
    url: https://api.example.com/health
    expected_code: 200
    
  - name: Web Frontend
    type: http
    url: https://www.example.com
    expected_code: 200
    
  - name: Main Database
    type: postgres
    connection: postgresql://user:pass@db.example.com/maindb
    
  - name: Redis Cache
    type: redis
    host: redis.example.com
    port: 6379
    
  - name: API SSL
    type: ssl
    domain: api.example.com
    warn_days: 30
```

## 🚀 Uso

### Manual

```bash
# Executar checks
./health-check.sh

# Output JSON
./health-check.sh --json

# Com notificação Slack
./health-check.sh --slack-webhook https://hooks.slack.com/...
```

### Cron (Periódico)

```bash
# Executar a cada 5 minutos
*/5 * * * * /opt/scripts/health-check.sh

# Executar a cada hora e notificar falhas
0 * * * * /opt/scripts/health-check.sh --slack-webhook $SLACK_WEBHOOK
```

### CI/CD Pipeline

```yaml
# .github/workflows/health-check.yml
name: Health Check

on:
  schedule:
    - cron: '*/15 * * * *'  # A cada 15 min
  workflow_dispatch:

jobs:
  health-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Run Health Checks
        run: ./scripts/health-check.sh --json > results.json
        
      - name: Upload Results
        uses: actions/upload-artifact@v3
        with:
          name: health-check-results
          path: results.json
```

## 📊 Integração com Monitoramento

### Prometheus Exporter

```python
from prometheus_client import Gauge, generate_latest

health_check_status = Gauge(
    'health_check_status',
    'Health check status (1=ok, 0=failed)',
    ['service']
)

def export_metrics(results):
    for result in results:
        status_value = 1 if result.status == 'ok' else 0
        health_check_status.labels(service=result.name).set(status_value)
    
    return generate_latest()
```

### Datadog

```python
from datadog import statsd

def send_to_datadog(results):
    for result in results:
        statsd.gauge(
            'health_check.status',
            1 if result.status == 'ok' else 0,
            tags=[f'service:{result.name}']
        )
        
        statsd.histogram(
            'health_check.duration',
            result.duration_ms,
            tags=[f'service:{result.name}']
        )
```

## ✅ Checklist

- [ ] Configurar todos os serviços críticos
- [ ] Definir thresholds apropriados
- [ ] Configurar notificações
- [ ] Adicionar ao cron/CI
- [ ] Integrar com monitoramento
- [ ] Testar falhas simuladas
- [ ] Documentar runbooks

## 📚 Referências

- [HTTP Health Check RFC](https://tools.ietf.org/html/draft-inadarei-api-health-check)
- [Kubernetes Health Checks](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/)
- [AWS Health Checks](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/target-group-health-checks.html)

---

**Health checks automatizados são essenciais para detectar problemas proativamente!** 🏥✨
