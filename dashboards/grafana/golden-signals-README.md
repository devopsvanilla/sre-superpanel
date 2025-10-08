# Golden Signals Dashboard

Dashboard Grafana para monitoramento dos quatro sinais dourados (Golden Signals) de um serviço.

## 📊 Descrição

Este dashboard implementa os quatro Golden Signals do Google SRE:
1. **Latência**: Tempo para servir requisições
2. **Tráfego**: Demanda no sistema (req/s)
3. **Erros**: Taxa de requisições que falham
4. **Saturação**: Utilização de recursos (CPU, memória, etc.)

## 🎯 Pré-requisitos

- Grafana >= 8.0
- Datasource: Prometheus
- Métricas necessárias:
  - `http_request_duration_seconds` (histogram)
  - `http_requests_total` (counter com labels: `code`, `method`)
  - `process_cpu_seconds_total` (gauge)
  - `process_resident_memory_bytes` (gauge)

## 📝 Variáveis do Dashboard

- `$datasource`: Prometheus datasource
- `$namespace`: Namespace/ambiente (ex: production, staging)
- `$service`: Nome do serviço a monitorar
- `$interval`: Intervalo de refresh (default: 30s)

## 📊 Painéis Incluídos

### Row 1: Overview

1. **Request Rate (QPS)**
   - Taxa de requisições por segundo
   - Quebrado por método HTTP

2. **Error Rate**
   - Porcentagem de erros (4xx + 5xx)
   - Alerta visual se > 1%

3. **P95 Latency**
   - Latência no percentil 95
   - Alerta visual se > SLO

4. **Availability**
   - Porcentagem de uptime
   - Baseado em requisições bem-sucedidas

### Row 2: Latência

5. **Latency Heatmap**
   - Distribuição de latência ao longo do tempo

6. **Latency Percentiles**
   - P50, P90, P95, P99
   - Visualização de tendências

7. **Slowest Endpoints**
   - Top 10 endpoints mais lentos

### Row 3: Tráfego

8. **Request Rate by Endpoint**
   - Taxa de requisições por endpoint
   - Identificar hotspots

9. **Request Rate by Status Code**
   - Quebrado por código HTTP (2xx, 3xx, 4xx, 5xx)

10. **Top Endpoints by Traffic**
    - Tabela com endpoints mais chamados

### Row 4: Erros

11. **Error Rate Over Time**
    - Taxa de erro ao longo do tempo
    - Com threshold de alerta

12. **Errors by Endpoint**
    - Erros agrupados por endpoint
    - Identificar endpoints problemáticos

13. **Error Types Distribution**
    - 4xx vs 5xx
    - Client errors vs Server errors

### Row 5: Saturação

14. **CPU Usage**
    - Utilização de CPU do serviço
    - Por instância

15. **Memory Usage**
    - Uso de memória RSS
    - Por instância

16. **Goroutines/Threads**
    - Número de threads/goroutines ativas
    - Indicador de resource leaks

## 🚀 Instalação

### Via UI do Grafana

1. Acesse Grafana > Dashboards > Import
2. Copie o conteúdo de `golden-signals-dashboard.json`
3. Cole no campo de importação
4. Selecione o datasource Prometheus
5. Clique em "Import"

### Via API

```bash
curl -X POST http://grafana:3000/api/dashboards/db \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -d @golden-signals-dashboard.json
```

### Via Terraform

```hcl
resource "grafana_dashboard" "golden_signals" {
  config_json = file("${path.module}/golden-signals-dashboard.json")
  folder      = grafana_folder.monitoring.id
}
```

## ⚙️ Configuração

### 1. Configurar Variáveis

Após importar, configure as variáveis:

- **datasource**: Selecione seu Prometheus
- **namespace**: Digite o namespace (ex: `production`)
- **service**: Nome do serviço (ex: `api-gateway`)

### 2. Ajustar Queries

As queries podem precisar de ajuste baseado nas suas labels:

```promql
# Query original
rate(http_requests_total{namespace="$namespace", service="$service"}[5m])

# Ajuste para suas labels
rate(http_requests_total{env="$namespace", app="$service"}[5m])
```

### 3. Definir Thresholds

Ajuste os thresholds de alerta para seus SLOs:

- **Error Rate**: Padrão < 1%, ajuste conforme seu SLO
- **Latency P95**: Padrão < 200ms, ajuste conforme seu SLO
- **CPU**: Padrão alerta em 80%, crítico em 90%
- **Memory**: Padrão alerta em 80%, crítico em 90%

## 🔔 Alertas Sugeridos

### Critical

```yaml
# Alta taxa de erro
- alert: HighErrorRate
  expr: |
    sum(rate(http_requests_total{code=~"5.."}[5m])) 
    / sum(rate(http_requests_total[5m])) > 0.05
  for: 5m
  labels:
    severity: critical

# Alta latência
- alert: HighLatency
  expr: |
    histogram_quantile(0.95,
      rate(http_request_duration_seconds_bucket[5m])
    ) > 1
  for: 5m
  labels:
    severity: critical
```

### Warning

```yaml
# CPU alto
- alert: HighCPU
  expr: |
    rate(process_cpu_seconds_total[5m]) > 0.8
  for: 10m
  labels:
    severity: warning

# Memória alta
- alert: HighMemory
  expr: |
    process_resident_memory_bytes > (8 * 1024 * 1024 * 1024)
  for: 10m
  labels:
    severity: warning
```

## 📸 Screenshots

*(Adicione screenshots do dashboard aqui)*

### Overview
![Overview Panel](screenshots/overview.png)

### Latency Details
![Latency Panel](screenshots/latency.png)

## 🎨 Personalização

### Adicionar Novo Painel

1. Edit dashboard
2. Add panel
3. Configure query
4. Set visualization
5. Save

### Exemplo: Adicionar Cache Hit Rate

```json
{
  "title": "Cache Hit Rate",
  "targets": [
    {
      "expr": "rate(cache_hits_total[5m]) / (rate(cache_hits_total[5m]) + rate(cache_misses_total[5m]))",
      "legendFormat": "Hit Rate"
    }
  ],
  "fieldConfig": {
    "defaults": {
      "unit": "percentunit",
      "thresholds": {
        "steps": [
          { "value": 0, "color": "red" },
          { "value": 0.8, "color": "yellow" },
          { "value": 0.95, "color": "green" }
        ]
      }
    }
  }
}
```

## 🔍 Troubleshooting

### Dashboard não mostra dados

1. **Verifique datasource**:
   - Dashboard settings > Variables > datasource

2. **Verifique métricas**:
   ```promql
   # Teste se métricas existem
   http_requests_total
   ```

3. **Verifique labels**:
   ```promql
   # Liste labels disponíveis
   {__name__=~"http_.*"}
   ```

4. **Ajuste time range**:
   - Tente aumentar o range (ex: Last 24 hours)

### Queries lentas

1. **Reduza resolution**:
   - Min interval: 30s → 1m

2. **Otimize queries**:
   ```promql
   # Evite
   sum(rate(http_requests_total[5m])) by (path)
   
   # Use
   sum(rate(http_requests_total[5m])) by (path) without (instance)
   ```

3. **Use recording rules** (Prometheus):
   ```yaml
   groups:
     - name: http_metrics
       interval: 30s
       rules:
         - record: job:http_requests:rate5m
           expr: sum(rate(http_requests_total[5m])) by (job)
   ```

## 📚 Referências

- [Google SRE Book - Monitoring Distributed Systems](https://sre.google/sre-book/monitoring-distributed-systems/)
- [The Four Golden Signals](https://sre.google/sre-book/monitoring-distributed-systems/#xref_monitoring_golden-signals)
- [Grafana Dashboard Best Practices](https://grafana.com/docs/grafana/latest/dashboards/build-dashboards/best-practices/)
- [Prometheus Query Examples](https://prometheus.io/docs/prometheus/latest/querying/examples/)

## 🤝 Contribuindo

Melhorias sugeridas:
- Adicionar painel de SLO/Error Budget
- Integrar com distributed tracing
- Adicionar business metrics
- Suporte para múltiplos serviços

---

**Dashboard Version**: 1.0  
**Last Updated**: 2025  
**Maintainer**: SRE SuperPanel Community
