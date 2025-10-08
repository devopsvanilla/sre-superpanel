# SLO: Disponibilidade de 99.9%

## Definição

```yaml
name: web_service_availability_slo
sli: http_availability
target: 0.999
window: 30d
description: |
  99.9% de todas as requisições HTTP devem ser bem-sucedidas 
  (códigos 2xx/3xx) em uma janela móvel de 30 dias
```

## Error Budget

### Cálculo

```
SLO Target: 99.9%
Error Budget: 100% - 99.9% = 0.1%

Em 30 dias:
- Total de minutos: 43,200
- Error Budget: 43,200 * 0.001 = 43.2 minutos
```

### Consumo do Error Budget

```promql
# Consumo atual do error budget (últimos 30 dias)
1 - (
  sum(rate(http_requests_total{code!~"5.."}[30d])) 
  / 
  sum(rate(http_requests_total[30d]))
)
```

## Alertas

### Multi-Window, Multi-Burn Rate

#### Alerta Critical (Page)

```yaml
alert: SLOBurnRateCritical
expr: |
  (
    (1 - sum(rate(http_requests_total{code!~"5.."}[1h])) 
         / sum(rate(http_requests_total[1h])))
    > (14.4 * 0.001)
  )
  and
  (
    (1 - sum(rate(http_requests_total{code!~"5.."}[5m])) 
         / sum(rate(http_requests_total[5m])))
    > (14.4 * 0.001)
  )
for: 2m
labels:
  severity: critical
  slo: availability
annotations:
  summary: "SLO burn rate crítico - error budget será consumido em < 2 dias"
  description: "Burn rate de 14.4x detectado. 2% do budget mensal será consumido em 1 hora"
```

**Burn Rate 14.4x**: Consome todo error budget em ~2 dias

#### Alerta Warning (Ticket)

```yaml
alert: SLOBurnRateWarning
expr: |
  (
    (1 - sum(rate(http_requests_total{code!~"5.."}[6h])) 
         / sum(rate(http_requests_total[6h])))
    > (6 * 0.001)
  )
  and
  (
    (1 - sum(rate(http_requests_total{code!~"5.."}[30m])) 
         / sum(rate(http_requests_total[30m])))
    > (6 * 0.001)
  )
for: 15m
labels:
  severity: warning
  slo: availability
annotations:
  summary: "SLO burn rate elevado - error budget será consumido em < 5 dias"
  description: "Burn rate de 6x detectado. Necessário investigação"
```

**Burn Rate 6x**: Consome todo error budget em ~5 dias

## Política de Error Budget

### Status do Budget

| Budget Restante | Ação |
|-----------------|------|
| > 75% | ✅ Deploy normal, experimentação permitida |
| 50% - 75% | ⚠️ Review aumentado de mudanças |
| 25% - 50% | 🟠 Apenas mudanças críticas, foco em estabilidade |
| < 25% | 🔴 Feature freeze, apenas hotfixes de segurança |

### Durante Feature Freeze

1. **Interromper**:
   - Deploy de novas features
   - Refatorações grandes
   - Experimentos

2. **Focar em**:
   - Análise de causa raiz
   - Melhorias de confiabilidade
   - Redução de toil
   - Automação de correções

3. **Permitido**:
   - Hotfix de segurança
   - Correções de bugs críticos
   - Rollbacks

## Dashboard

### Panels Recomendados

1. **SLI Current Value**
   ```promql
   sum(rate(http_requests_total{code!~"5.."}[5m])) 
   / 
   sum(rate(http_requests_total[5m]))
   ```

2. **Error Budget Remaining (30d)**
   ```promql
   1 - (
     (1 - sum(rate(http_requests_total{code!~"5.."}[30d])) 
          / sum(rate(http_requests_total[30d])))
     / 0.001
   )
   ```

3. **Error Budget Burn Rate**
   ```promql
   (1 - sum(rate(http_requests_total{code!~"5.."}[1h])) 
        / sum(rate(http_requests_total[1h])))
   / 0.001
   ```

4. **Availability Trend (7d)**
   ```promql
   sum(rate(http_requests_total{code!~"5.."}[1h])) 
   / 
   sum(rate(http_requests_total[1h]))
   ```

## Validação

### Checklist de Implementação

- [ ] SLI está sendo coletado corretamente
- [ ] Dashboard mostra valores esperados
- [ ] Alertas configurados e testados
- [ ] Equipe entende o SLO
- [ ] Política de error budget documentada
- [ ] Runbook de resposta criado

### Teste do SLO

```bash
# Simular falhas para testar alertas
# NÃO executar em produção!
for i in {1..1000}; do
  curl -X GET http://test-service/simulate-error
done
```

## Revisão do SLO

### Quando Revisar

- Trimestralmente ou após incidentes maiores
- Quando SLO é muito fácil/difícil de atingir
- Mudanças no produto/requisitos

### Perguntas para Revisão

1. O SLO reflete a experiência do usuário?
2. Os alertas estão acionáveis?
3. A política de error budget está sendo seguida?
4. Há muito/pouco error budget?

## Referências

- [Alerting on SLOs](https://sre.google/workbook/alerting-on-slos/)
- [Error Budget Policy](https://sre.google/workbook/error-budget-policy/)
- [Multi-Window Multi-Burn-Rate Alerts](https://sre.google/workbook/alerting-on-slos/#6-multiwindow-multi-burn-rate-alerts)
