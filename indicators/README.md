# 📈 Indicadores

Esta pasta contém indicadores de performance, SLIs (Service Level Indicators) e SLOs (Service Level Objectives) curados para diferentes tipos de serviços e aplicações.

## 📁 Estrutura

```
indicators/
├── slis/              # Service Level Indicators
├── slos/              # Service Level Objectives
├── golden-signals/    # Métricas de Golden Signals
└── README.md         # Este arquivo
```

## 🎯 O que são Indicadores?

### SLI - Service Level Indicator
Métricas quantitativas que medem aspectos do nível de serviço fornecido. São a base para definir SLOs.

**Exemplos:**
- Taxa de disponibilidade (uptime)
- Latência de requisições
- Taxa de erros
- Throughput

### SLO - Service Level Objective
Objetivos definidos para SLIs. Representam o nível de serviço aceitável para os usuários.

**Exemplos:**
- 99.9% de disponibilidade
- 95% das requisições < 200ms
- Taxa de erro < 0.1%

### Golden Signals
Framework do Google SRE para monitoramento:
- **Latência**: Tempo para servir uma requisição
- **Tráfego**: Demanda no sistema
- **Erros**: Taxa de requisições que falham
- **Saturação**: Quão "cheio" está o serviço

## 📊 Indicadores Disponíveis

### Por Tipo de Serviço

#### API/Web Services
- Disponibilidade HTTP
- Latência de requisições (p50, p95, p99)
- Taxa de erros 5xx
- Throughput (req/s)

#### Bancos de Dados
- Disponibilidade de conexão
- Query latency
- Taxa de deadlocks
- Replication lag

#### Message Queues
- Message processing latency
- Queue depth
- Message loss rate
- Consumer lag

#### Kubernetes
- Pod availability
- Container restart rate
- Node resource utilization
- Deployment success rate

## 🚀 Como Usar

### 1. Escolher SLIs Apropriados

```bash
# Explorar SLIs por categoria
ls indicators/slis/

# Ver exemplo de SLI
cat indicators/slis/web-service/availability.yaml
```

### 2. Definir SLOs

```bash
# Ver SLOs recomendados
cat indicators/slos/web-service/availability-slo.yaml
```

### 3. Implementar no Sistema

Exemplo com Prometheus:

```yaml
# SLI: Taxa de disponibilidade
availability_sli = sum(rate(http_requests_total{code!~"5.."}[5m])) 
                  / sum(rate(http_requests_total[5m]))

# SLO: 99.9% de disponibilidade
slo_target = 0.999
```

## 📝 Estrutura de Arquivo

### SLI Template

```yaml
name: "availability"
description: "Mede a disponibilidade do serviço baseado em códigos HTTP"
type: "availability"
calculation:
  prometheus: |
    sum(rate(http_requests_total{code!~"5.."}[5m])) 
    / sum(rate(http_requests_total[5m]))
unit: "percentage"
interpretation:
  good: "> 0.99"
  acceptable: "0.95 - 0.99"
  poor: "< 0.95"
```

### SLO Template

```yaml
name: "availability-slo"
sli: "availability"
target: 0.999
window: "30d"
error_budget: 0.001
calculation:
  error_budget_minutes: 43.2  # 0.1% de 30 dias
alerting:
  burn_rate:
    - window: "1h"
      threshold: 14.4
    - window: "6h" 
      threshold: 6
```

## 🎯 Definindo SLOs Efetivos

### Princípios

1. **Baseado em Usuário**: SLOs devem refletir a experiência do usuário
2. **Mensurável**: Deve ser possível medir objetivamente
3. **Alcançável**: Realista dado o sistema atual
4. **Relevante**: Importante para o negócio

### Processo

1. **Identificar SLIs críticos**
   - O que impacta o usuário?
   - Quais métricas são mensuráveis?

2. **Definir threshold inicial**
   - Analise dados históricos
   - Comece conservador

3. **Calcular Error Budget**
   ```
   Error Budget = 100% - SLO
   
   Exemplo: SLO 99.9%
   Error Budget = 0.1% = 43.2 min/mês
   ```

4. **Configurar Alertas**
   - Multi-window, multi-burn-rate
   - Evitar alert fatigue

## 📚 Golden Signals em Detalhes

### 1. Latência

```yaml
# P99 Latency SLI
name: "latency_p99"
percentile: 99
target: "200ms"
prometheus: |
  histogram_quantile(0.99, 
    rate(http_request_duration_seconds_bucket[5m])
  )
```

### 2. Tráfego

```yaml
# Request Rate SLI
name: "request_rate"
target: "1000 req/s"
prometheus: |
  sum(rate(http_requests_total[5m]))
```

### 3. Erros

```yaml
# Error Rate SLI
name: "error_rate"
target: "< 0.1%"
prometheus: |
  sum(rate(http_requests_total{code=~"5.."}[5m])) 
  / sum(rate(http_requests_total[5m]))
```

### 4. Saturação

```yaml
# CPU Saturation SLI
name: "cpu_saturation"
target: "< 80%"
prometheus: |
  100 - (avg(rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
```

## 🔧 Error Budget Policies

### Quando Error Budget está OK
- Deploy normal
- Experimentação permitida
- Foco em features

### Quando Error Budget está esgotado
- Freeze de deploys não críticos
- Foco em confiabilidade
- Análise de causa raiz

### Exemplo de Política

```markdown
| Error Budget Restante | Ação                           |
|-----------------------|--------------------------------|
| > 50%                 | Deploy normal                  |
| 25% - 50%             | Review de mudanças aumentado   |
| 10% - 25%             | Apenas fixes críticos          |
| < 10%                 | Feature freeze                 |
```

## 🤝 Contribuindo

Para adicionar novos indicadores:

1. Escolha a categoria apropriada
2. Use o template YAML
3. Inclua exemplos de implementação
4. Documente interpretação
5. Adicione referências

### Checklist

- [ ] SLI bem definido e mensurável
- [ ] SLO baseado em requisitos reais
- [ ] Queries validadas
- [ ] Error budget calculado
- [ ] Alertas configurados
- [ ] Documentação completa

## 📖 Recursos

- [Google SRE Book - Service Level Objectives](https://sre.google/sre-book/service-level-objectives/)
- [The Four Golden Signals](https://sre.google/sre-book/monitoring-distributed-systems/#xref_monitoring_golden-signals)
- [Implementing SLOs](https://sre.google/workbook/implementing-slos/)
- [Error Budget Policies](https://sre.google/workbook/error-budget-policy/)

## 🆘 Suporte

Dúvidas sobre indicadores?

1. Consulte a documentação de cada SLI/SLO
2. Revise exemplos práticos
3. Abra uma issue no GitHub
4. Compartilhe seu caso de uso

---

**SLIs e SLOs bem definidos são a base da confiabilidade!** 📈✨
