# SLI: Disponibilidade HTTP

## Descrição

Mede a disponibilidade de um serviço baseado em respostas HTTP bem-sucedidas vs total de requisições.

## Definição

```yaml
name: http_availability
type: availability
description: |
  Porcentagem de requisições HTTP que retornam códigos 2xx ou 3xx 
  (sucesso) em relação ao total de requisições
```

## Cálculo

### Prometheus

```promql
# Disponibilidade em janela de 5 minutos
sum(rate(http_requests_total{code!~"5.."}[5m])) 
/ 
sum(rate(http_requests_total[5m]))
```

### Alternativas

**DataDog:**
```
sum:http.requests{!status:5*}.as_count() 
/ 
sum:http.requests{*}.as_count()
```

**CloudWatch:**
```
(RequestCount - 5XXError) / RequestCount
```

## Interpretação

| Valor | Interpretação | Ação |
|-------|---------------|------|
| > 99.9% | Excelente | Manter |
| 99.0% - 99.9% | Bom | Monitorar tendências |
| 95.0% - 99.0% | Aceitável | Investigar causas |
| < 95.0% | Crítico | Ação imediata necessária |

## Métricas Necessárias

- `http_requests_total`: Total de requisições HTTP
  - Labels: `code` (código HTTP), `method`, `path`

## Exemplo de Exportação

### Python (Prometheus Client)

```python
from prometheus_client import Counter

http_requests = Counter(
    'http_requests_total',
    'Total HTTP requests',
    ['code', 'method', 'path']
)

# Em cada requisição
@app.route('/api/users')
def get_users():
    try:
        result = fetch_users()
        http_requests.labels(code='200', method='GET', path='/api/users').inc()
        return result
    except Exception as e:
        http_requests.labels(code='500', method='GET', path='/api/users').inc()
        raise
```

## SLO Recomendado

- **Web Services Críticos**: 99.9% (43.2 min downtime/mês)
- **Web Services Padrão**: 99.5% (3.6 horas downtime/mês)
- **Serviços Internos**: 99.0% (7.2 horas downtime/mês)

## Limitações

- Não captura problemas de latência
- Não diferencia entre tipos de erro 5xx
- Pode não refletir experiência real do usuário (ex: timeouts)

## Complementos Sugeridos

- Latency SLI (p95, p99)
- Success Rate por endpoint crítico
- Client-side availability (RUM)

## Referências

- [Google SRE Book - SLI Menu](https://sre.google/workbook/implementing-slos/)
- [Prometheus Best Practices](https://prometheus.io/docs/practices/naming/)
