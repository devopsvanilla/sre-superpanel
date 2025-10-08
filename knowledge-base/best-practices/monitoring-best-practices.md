# Melhores Práticas de Monitoramento

Este documento descreve práticas recomendadas para implementar monitoramento efetivo em sistemas de produção.

## 🎯 Princípios Fundamentais

### 1. Monitore Sintomas, Não Causas

❌ **Evite**:
- Alertar quando CPU > 80%
- Alertar quando disco > 90%
- Alertar quando memória > 85%

✅ **Faça**:
- Alertar quando latência > SLO
- Alertar quando error rate > SLO
- Alertar quando availability < SLO

**Por quê?**: Recursos altos podem não afetar usuários. Foque no impacto.

### 2. Use SLOs Como Guia

```yaml
# Defina SLOs claros
availability_slo: 99.9%
latency_p95_slo: 200ms
error_rate_slo: 0.1%

# Configure alertas baseados em SLOs
alert: AvailabilityBelowSLO
expr: availability < 0.999
for: 5m
```

### 3. Evite Alert Fatigue

**Regras de Ouro**:
- Todo alerta deve ser **acionável**
- Todo alerta deve requerer **ação humana**
- Todo alerta deve ser **urgente**

Se não atende os três critérios, não é um alerta - é uma métrica para dashboard.

### 4. Use Severidades Apropriadas

| Severidade | Quando Usar | Resposta Esperada |
|------------|-------------|-------------------|
| **Critical** | Impacto direto no usuário | Ação imediata, pode acordar on-call |
| **Warning** | Risco de impacto futuro | Investigar em horário comercial |
| **Info** | FYI, sem ação necessária | Apenas registrar |

## 📊 Os Quatro Golden Signals

### 1. Latência

**O que medir**: Tempo para processar requisições

```promql
# P50, P95, P99
histogram_quantile(0.50, rate(http_request_duration_seconds_bucket[5m]))
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))
histogram_quantile(0.99, rate(http_request_duration_seconds_bucket[5m]))
```

**Boas Práticas**:
- Use histogramas, não médias
- Monitore percentis (P95, P99)
- Separe latência de sucesso vs erro
- Identifique outliers

### 2. Tráfego

**O que medir**: Demanda no sistema

```promql
# Requisições por segundo
sum(rate(http_requests_total[5m]))

# Por endpoint
sum by (path) (rate(http_requests_total[5m]))
```

**Boas Práticas**:
- Monitore tendências
- Compare com períodos anteriores
- Identifique picos anormais
- Correlacione com deploys

### 3. Erros

**O que medir**: Taxa de requisições que falham

```promql
# Error rate
sum(rate(http_requests_total{code=~"5.."}[5m])) 
/ 
sum(rate(http_requests_total[5m]))
```

**Boas Práticas**:
- Separe erros 4xx (client) de 5xx (server)
- Monitore por endpoint
- Track error types/mensagens
- Correlacione com releases

### 4. Saturação

**O que medir**: Quão "cheio" está o sistema

```promql
# CPU
100 - (avg(rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Memória
(node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) 
/ node_memory_MemTotal_bytes * 100

# Disk I/O
rate(node_disk_io_time_seconds_total[5m])
```

**Boas Práticas**:
- Monitore leading indicators (queue depth)
- Use percentis de utilização
- Configure headroom apropriado
- Preveja saturação futura

## 🎨 Design de Dashboards

### Hierarquia de Dashboards

```
1. Overview Dashboard (CEO view)
   ├── SLOs status
   ├── Error budget
   └── Key business metrics

2. Service Dashboard (Service owner view)
   ├── Golden Signals
   ├── Resource utilization
   └── Dependencies health

3. Detailed Dashboard (Debug view)
   ├── Per-endpoint metrics
   ├── Database queries
   └── Cache performance
```

### Princípios de Design

1. **Organização**:
   - Overview no topo
   - Detalhes embaixo
   - Agrupe painéis relacionados

2. **Cores com Significado**:
   - Verde: Saudável
   - Amarelo: Atenção
   - Vermelho: Problema
   - Azul: Neutro/info

3. **Context é Importante**:
   ```promql
   # Ruim: Só o valor
   cpu_usage
   
   # Bom: Com threshold
   cpu_usage (threshold: 80%)
   
   # Melhor: Com SLO
   cpu_usage (SLO: < 70% p95)
   ```

4. **Evite Dashboard Overload**:
   - Max 15-20 painéis por dashboard
   - Use drill-downs para detalhes
   - Remova métricas não usadas

## 🔔 Configuração de Alertas

### Multi-Window, Multi-Burn Rate

Método recomendado do Google SRE:

```yaml
# Fast burn (2% budget em 1h)
- alert: ErrorBudgetBurnFast
  expr: |
    error_rate_1h > (14.4 * slo_error_budget)
    and
    error_rate_5m > (14.4 * slo_error_budget)
  for: 2m
  labels:
    severity: critical

# Slow burn (10% budget em 24h)
- alert: ErrorBudgetBurnSlow
  expr: |
    error_rate_6h > (6 * slo_error_budget)
    and
    error_rate_30m > (6 * slo_error_budget)
  for: 15m
  labels:
    severity: warning
```

### Estrutura de Alerta

```yaml
alert: [NomeDescritivo]
expr: [Query PromQL]
for: [Duração antes de disparar]
labels:
  severity: [critical|warning|info]
  team: [time responsável]
  service: [serviço afetado]
annotations:
  summary: "[Descrição curta]"
  description: "[Detalhes e impacto]"
  runbook: "[URL do runbook]"
  dashboard: "[URL do dashboard]"
```

### Checklist de Alerta

Antes de criar um alerta, pergunte:

- [ ] Este alerta é **acionável**?
- [ ] Requer **ação humana imediata**?
- [ ] Impacta **usuários**?
- [ ] Tem um **runbook** associado?
- [ ] A **severidade** está correta?
- [ ] O **threshold** está calibrado?
- [ ] O **for** evita flapping?

## 📏 Métricas vs Logs vs Traces

### Quando Usar Cada Um

| Tipo | Quando Usar | Exemplo |
|------|-------------|---------|
| **Métricas** | Agregações, tendências, alertas | Request rate, latency, error rate |
| **Logs** | Debugging, audit trail | Error messages, request logs |
| **Traces** | Debugging distribuído | Request flow, bottlenecks |

### Integração

```python
# Exemplo: Correlação entre os três

# 1. Métrica mostra problema
alert: HighLatency
expr: p95_latency > 1s

# 2. Log mostra erro
2025-01-08 10:23:45 ERROR Database timeout on query: SELECT * FROM users

# 3. Trace mostra onde
Trace ID: abc123
├─ API Gateway: 50ms
├─ Auth Service: 30ms  
└─ Database: 1500ms ← bottleneck!
```

## 🎓 Métricas Avançadas

### RED Method (Serviços)

- **R**ate: Requisições por segundo
- **E**rrors: Quantidade de erros
- **D**uration: Latência

```promql
# Rate
sum(rate(http_requests_total[5m]))

# Errors
sum(rate(http_requests_total{code=~"5.."}[5m]))

# Duration
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))
```

### USE Method (Recursos)

- **U**tilization: % do recurso usado
- **S**aturation: Trabalho enfileirado
- **E**rrors: Erros do recurso

```promql
# CPU Utilization
100 - (avg(rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# CPU Saturation (load average)
node_load1 / node_cpu_count

# Errors (context switches)
rate(node_context_switches_total[5m])
```

## 🔍 Troubleshooting Monitoring

### Dashboard não mostra dados

1. Verifique se métricas estão sendo exportadas
2. Confirme labels nas queries
3. Ajuste time range
4. Verifique datasource

### Alertas não disparam

1. Teste a query manualmente
2. Verifique o threshold
3. Confirme o período `for`
4. Valide route de notificação

### Muitos falsos positivos

1. Ajuste threshold
2. Aumente período `for`
3. Use multi-window alerting
4. Revise se alerta é necessário

## 📚 Recursos

- [Google SRE - Monitoring Distributed Systems](https://sre.google/sre-book/monitoring-distributed-systems/)
- [Prometheus Best Practices](https://prometheus.io/docs/practices/naming/)
- [The RED Method](https://www.weave.works/blog/the-red-method-key-metrics-for-microservices-architecture/)
- [The USE Method](http://www.brendangregg.com/usemethod.html)

## ✅ Checklist de Implementação

- [ ] SLIs definidos para serviços críticos
- [ ] SLOs estabelecidos com stakeholders
- [ ] Dashboards hierárquicos criados
- [ ] Alertas acionáveis configurados
- [ ] Runbooks associados a alertas
- [ ] On-call rotation definida
- [ ] Postmortem process estabelecido
- [ ] Review trimestral agendado

---

**Lembre-se**: Bom monitoramento não é sobre quantidade de métricas, mas sobre insights acionáveis!
