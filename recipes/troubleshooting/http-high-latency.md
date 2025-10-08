# Troubleshooting: Alta Latência HTTP

## 📋 Visão Geral

**Problema**: Requisições HTTP com latência acima do esperado  
**Severidade**: Alta  
**Tempo Estimado**: 15-30 minutos

## 🎯 Quando Usar

Use esta receita quando observar:
- P95 ou P99 de latência acima do SLO
- Alertas de latência disparando
- Reclamações de usuários sobre lentidão
- Timeouts em requisições

## ⚠️ Pré-requisitos

- Acesso ao sistema de métricas (Prometheus, DataDog, etc.)
- Acesso aos logs da aplicação
- Acesso ao sistema de tracing (Jaeger, Zipkin, etc.) se disponível
- Permissões para visualizar dashboards

## 🔍 Diagnóstico

### Passo 1: Confirmar o Problema

Verifique as métricas de latência:

```promql
# P95 de latência HTTP (últimos 5min)
histogram_quantile(0.95, 
  rate(http_request_duration_seconds_bucket[5m])
)

# P99 de latência HTTP (últimos 5min)
histogram_quantile(0.99, 
  rate(http_request_duration_seconds_bucket[5m])
)
```

**Saída Esperada**: Valores dentro do SLO (ex: < 200ms)  
**Se acima do SLO**: Continue para próximo passo

### Passo 2: Identificar Escopo do Problema

#### 2.1. Por Endpoint

```promql
# Latência por endpoint
histogram_quantile(0.95,
  sum by (path) (rate(http_request_duration_seconds_bucket[5m]))
)
```

**Análise**:
- ✅ Um endpoint específico: Problema localizado
- ⚠️ Todos endpoints: Problema sistêmico

#### 2.2. Por Instância

```promql
# Latência por instância
histogram_quantile(0.95,
  sum by (instance) (rate(http_request_duration_seconds_bucket[5m]))
)
```

**Análise**:
- ✅ Uma instância: Problema na instância
- ⚠️ Todas instâncias: Problema de dependência ou carga

### Passo 3: Verificar Recursos do Sistema

#### 3.1. CPU

```promql
# Uso de CPU por instância
100 - (avg by (instance) (
  rate(node_cpu_seconds_total{mode="idle"}[5m])
) * 100)
```

**Threshold**: > 80% = possível bottleneck

#### 3.2. Memória

```promql
# Uso de memória
(node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) 
/ node_memory_MemTotal_bytes * 100
```

**Threshold**: > 90% = possível pressure

#### 3.3. I/O de Disco

```bash
# No servidor afetado
iostat -x 1 5

# Verifique:
# - %util > 80%: Disco saturado
# - await > 10ms: Alta latência de I/O
```

### Passo 4: Verificar Dependências

#### 4.1. Database

```promql
# Latência de queries no DB
histogram_quantile(0.95,
  rate(db_query_duration_seconds_bucket[5m])
)

# Conexões ativas
db_connections_active
```

**Se alta latência no DB**: Ver receita `db-high-latency.md`

#### 4.2. APIs Externas

```promql
# Latência de chamadas externas
histogram_quantile(0.95,
  rate(external_api_duration_seconds_bucket[5m])
)
```

#### 4.3. Cache

```promql
# Cache hit rate
rate(cache_hits_total[5m]) / 
(rate(cache_hits_total[5m]) + rate(cache_misses_total[5m]))
```

**Esperado**: > 80%  
**Se baixo**: Cache não está efetivo

### Passo 5: Analisar Traces (se disponível)

```bash
# Buscar traces lentos no Jaeger
# Query para traces > 1s nos últimos 15min
curl "http://jaeger:16686/api/traces?service=my-service&limit=20&lookback=15m&minDuration=1s"
```

Analise:
- Qual span está lento?
- É problema de DB, API externa, ou processamento?

## 🛠️ Solução

### Solução 1: Problema de Carga (CPU/Memória Alto)

**Quando usar**: CPU > 80% ou Memória > 90%

#### Curto Prazo (Mitigação)

```bash
# Escalar horizontalmente (Kubernetes)
kubectl scale deployment my-service --replicas=10

# Ou aumentar recursos (vertical)
kubectl set resources deployment my-service \
  --limits=cpu=2000m,memory=4Gi \
  --requests=cpu=1000m,memory=2Gi
```

#### Longo Prazo (Correção)

- Profile da aplicação para encontrar bottlenecks
- Otimizar código ineficiente
- Implementar caching
- Configurar auto-scaling

### Solução 2: Problema de Database

**Quando usar**: Latência alta em queries DB

```bash
# Verificar queries lentas
mysql -e "SHOW FULL PROCESSLIST;"

# PostgreSQL
psql -c "SELECT pid, query, state, wait_event 
         FROM pg_stat_activity 
         WHERE state = 'active';"
```

**Ações**:
1. Identificar queries lentas
2. Analisar planos de execução
3. Adicionar índices se necessário
4. Considerar query caching

### Solução 3: Problema de Conexões (Database/APIs)

**Quando usar**: Pool de conexões saturado

```bash
# Aumentar pool de conexões (exemplo Spring Boot)
# application.properties
spring.datasource.hikari.maximum-pool-size=50
spring.datasource.hikari.minimum-idle=10
```

**Atenção**: Não aumentar indefinidamente, pode sobrecarregar DB

### Solução 4: Cache Inefetivo

**Quando usar**: Cache hit rate < 80%

```python
# Exemplo: Adicionar caching
from functools import lru_cache

@lru_cache(maxsize=1000)
def get_user_data(user_id):
    # Operação cara
    return fetch_from_db(user_id)
```

### Solução 5: Timeout de APIs Externas

**Quando usar**: API externa está lenta

```python
# Implementar timeout e fallback
import requests
from requests.adapters import HTTPAdapter
from requests.packages.urllib3.util.retry import Retry

def call_external_api():
    session = requests.Session()
    retry = Retry(total=3, backoff_factor=0.3)
    adapter = HTTPAdapter(max_retries=retry)
    session.mount('http://', adapter)
    
    try:
        response = session.get(
            'http://external-api.com/data',
            timeout=2  # 2 segundos
        )
        return response.json()
    except requests.Timeout:
        # Fallback ou cache
        return get_cached_data()
```

## ✅ Verificação

Após aplicar solução, verifique:

1. **Latência voltou ao normal?**
   ```promql
   histogram_quantile(0.95, 
     rate(http_request_duration_seconds_bucket[5m])
   )
   ```

2. **Recursos estabilizaram?**
   - CPU < 70%
   - Memória < 80%
   - Conexões DB estáveis

3. **Usuários reportam melhoria?**

## 🚫 Rollback

Se a solução piorou a situação:

```bash
# Reverter scaling
kubectl scale deployment my-service --replicas=<valor-anterior>

# Reverter configuração
kubectl rollout undo deployment/my-service

# Restaurar pool de conexões
# Reverter mudança em application.properties e redeployar
```

## 📊 Monitoramento Pós-Correção

Monitore por 24-48h:

1. **Latência P95/P99**
2. **Taxa de erro**
3. **Utilização de recursos**
4. **Dependências (DB, APIs)**

Dashboard sugerido:
```promql
# Panel 1: Latência
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))

# Panel 2: CPU
100 - (avg(rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Panel 3: Memória
(node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100

# Panel 4: DB Latency
histogram_quantile(0.95, rate(db_query_duration_seconds_bucket[5m]))
```

## 🔄 Prevenção

Para evitar este problema no futuro:

1. **Implementar Auto-scaling**
   ```yaml
   # HPA para Kubernetes
   apiVersion: autoscaling/v2
   kind: HorizontalPodAutoscaler
   metadata:
     name: my-service-hpa
   spec:
     scaleTargetRef:
       apiVersion: apps/v1
       kind: Deployment
       name: my-service
     minReplicas: 3
     maxReplicas: 20
     metrics:
     - type: Resource
       resource:
         name: cpu
         target:
           type: Utilization
           averageUtilization: 70
     - type: Resource
       resource:
         name: memory
         target:
           type: Utilization
           averageUtilization: 80
   ```

2. **Configurar Alertas Proativos**
   ```yaml
   # Alerta de latência crescente
   alert: LatencyIncreasing
   expr: |
     histogram_quantile(0.95, 
       rate(http_request_duration_seconds_bucket[5m])
     ) > 0.15  # 150ms
   for: 5m
   ```

3. **Load Testing Regular**
   ```bash
   # Teste de carga com k6
   k6 run --vus 100 --duration 10m load-test.js
   ```

4. **Capacity Planning**
   - Projetar crescimento de tráfego
   - Provisionar com headroom (30-40%)
   - Review trimestral de capacidade

5. **Otimizações Contínuas**
   - Profile regular da aplicação
   - Otimizar queries N+1
   - Implementar caching efetivo
   - Usar CDN para assets estáticos

## 📚 Referências

- [Google SRE Book - Monitoring](https://sre.google/sre-book/monitoring-distributed-systems/)
- [Latency Percentiles](https://www.brendangregg.com/blog/2016-10-04/dtrace-for-linux-2016.html)
- [Database Performance](https://use-the-index-luke.com/)

## 📝 Histórico de Uso

| Data | Usuário | Resultado | Notas |
|------|---------|-----------|-------|
| - | - | - | _Adicione suas experiências aqui_ |
