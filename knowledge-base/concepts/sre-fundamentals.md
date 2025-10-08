# Fundamentos de SRE (Site Reliability Engineering)

## 📖 O que é SRE?

Site Reliability Engineering (SRE) é uma disciplina que incorpora aspectos de engenharia de software e aplica-os a problemas de infraestrutura e operações. O objetivo é criar sistemas de software escaláveis e altamente confiáveis.

> "SRE é o que acontece quando você pede a um engenheiro de software para projetar uma equipe de operações." - Ben Treynor Sloss, VP of Engineering at Google

## 🎯 Princípios Fundamentais

### 1. Abraçar o Risco

- **Conceito**: Sistemas 100% confiáveis são impossíveis e não econômicos
- **Prática**: Definir níveis aceitáveis de confiabilidade através de SLOs
- **Benefício**: Balanço entre velocidade de inovação e estabilidade

**Exemplo**: Se o SLO é 99.9%, temos 0.1% de "budget" para falhas e experimentação.

### 2. Service Level Objectives (SLOs)

Objetivos numéricos precisos para o nível de serviço desejado.

**Hierarquia**:
- **SLI** (Service Level Indicator): Métrica que mede algo
- **SLO** (Service Level Objective): Objetivo para o SLI
- **SLA** (Service Level Agreement): Acordo comercial com consequências

**Exemplo**:
```yaml
SLI: Taxa de sucesso de requisições HTTP
SLO: 99.9% de requisições bem-sucedidas em 30 dias
SLA: Crédito de 10% se SLO não for atingido
```

### 3. Error Budgets

```
Error Budget = 100% - SLO
```

**Conceito**: Quantidade aceitável de falhas em um período.

**Uso**:
- ✅ Budget disponível → Deploy de novas features
- ❌ Budget esgotado → Foco em confiabilidade

**Exemplo**:
```
SLO: 99.9% uptime mensal
Error Budget: 0.1% = 43.2 minutos/mês

Se gastamos 30 minutos em outages:
Budget restante: 13.2 minutos
```

### 4. Eliminar Toil

**Toil** é trabalho operacional que é:
- Manual
- Repetitivo
- Automatizável
- Tático (não estratégico)
- Cresce linearmente com o serviço

**Meta**: < 50% do tempo em toil, > 50% em engenharia

**Estratégias**:
- Automação
- Self-service
- Better tools
- Processo optimization

### 5. Monitoramento

Quatro Golden Signals (Google SRE):

1. **Latência**: Tempo para servir requisição
2. **Tráfego**: Demanda no sistema
3. **Erros**: Taxa de requisições que falham
4. **Saturação**: Quão "cheio" está o sistema

### 6. Postmortems Blameless

Após incidentes:
- Documentar o que aconteceu
- Identificar causa raiz
- Definir action items
- **Sem culpa individual** → Foco em melhorias sistêmicas

### 7. Capacidade de Planejamento

- Projeção de demanda futura
- Testes de carga regulares
- Headroom apropriado (30-50%)
- Review trimestral

## 🔄 Ciclo de Vida SRE

```
┌─────────────┐
│   Design    │ → Arquitetura para confiabilidade
└──────┬──────┘
       ↓
┌─────────────┐
│   Build     │ → Implementação com observabilidade
└──────┬──────┘
       ↓
┌─────────────┐
│   Deploy    │ → Deploys seguros e graduais
└──────┬──────┘
       ↓
┌─────────────┐
│  Monitor    │ → Métricas, logs, traces
└──────┬──────┘
       ↓
┌─────────────┐
│  Respond    │ → Incident response, postmortems
└──────┬──────┘
       ↓
┌─────────────┐
│   Improve   │ → Automação, redução de toil
└──────┬──────┘
       ↓
    (repeat)
```

## 📊 Diferenças: SRE vs DevOps vs Operations

| Aspecto | Operations Tradicional | DevOps | SRE |
|---------|------------------------|--------|-----|
| Foco | Estabilidade | Velocidade + Estabilidade | Engenharia de confiabilidade |
| Mudanças | Cauteloso | Rápido | Baseado em error budget |
| Automação | Limitada | Encorajada | Mandatória |
| Métricas | Uptime | DORA metrics | SLIs/SLOs |
| On-call | 24/7 | Shared | Max 50% do tempo |

## 🎓 Competências de um SRE

### Técnicas
- **Software Engineering**: Código, arquitetura, testes
- **Systems Engineering**: Linux, rede, performance
- **Observabilidade**: Métricas, logs, traces, dashboards
- **Automação**: Scripts, IaC, CI/CD

### Não-Técnicas
- **Comunicação**: Incident response, postmortems
- **Colaboração**: Entre times de dev e ops
- **Priorização**: Balancear features vs confiabilidade
- **Pensamento Sistêmico**: Causa raiz, não sintomas

## 🛠️ Ferramentas Comuns

### Observabilidade
- **Métricas**: Prometheus, DataDog, New Relic
- **Logs**: ELK, Splunk, Loki
- **Traces**: Jaeger, Zipkin, Lightstep
- **Dashboards**: Grafana, Kibana

### Automação
- **IaC**: Terraform, Pulumi, CloudFormation
- **Configuration**: Ansible, Chef, Puppet
- **CI/CD**: Jenkins, GitLab CI, GitHub Actions

### Orquestração
- **Containers**: Docker, Podman
- **Orchestration**: Kubernetes, Nomad, ECS

## 📈 Métricas de Sucesso SRE

### Confiabilidade
- SLO compliance (% do tempo atingindo SLOs)
- MTBF (Mean Time Between Failures)
- MTTR (Mean Time To Recovery)

### Eficiência
- Toil percentage (< 50%)
- Automation coverage
- On-call load (alerts/week)

### Velocidade
- Deployment frequency
- Lead time for changes
- Change failure rate

## 🚀 Implementando SRE

### Fase 1: Fundação (Mês 1-3)
1. Definir SLIs para serviços críticos
2. Estabelecer SLOs baseados em dados históricos
3. Implementar monitoramento básico
4. Criar runbooks para incidentes comuns

### Fase 2: Operação (Mês 4-6)
1. Error budget tracking
2. On-call rotation
3. Postmortem process
4. Alerting refinement

### Fase 3: Otimização (Mês 7-12)
1. Redução de toil através de automação
2. Capacity planning
3. Chaos engineering
4. Multi-region/HA

### Fase 4: Escala (Ano 2+)
1. Platform teams
2. Self-service tools
3. Advanced observability
4. Reliability as a culture

## 📚 Recursos para Aprender

### Livros
- **Site Reliability Engineering** (The SRE Book) - Google
- **The Site Reliability Workbook** - Google
- **Seeking SRE** - David Blank-Edelman
- **Database Reliability Engineering** - Laine Campbell & Charity Majors

### Cursos
- [Google Cloud SRE Training](https://cloud.google.com/training/sre)
- [Linux Foundation SRE](https://training.linuxfoundation.org/training/sre/)
- [Coursera - SRE Fundamentals](https://www.coursera.org/specializations/site-reliability-engineering-sre)

### Comunidades
- [SRE Weekly Newsletter](https://sreweekly.com/)
- [r/sre on Reddit](https://www.reddit.com/r/sre/)
- [USENIX SREcon](https://www.usenix.org/conferences/byname/925)

### Blogs
- [Google SRE](https://sre.google/)
- [Netflix Tech Blog](https://netflixtechblog.com/)
- [Uber Engineering](https://eng.uber.com/)

## 🔑 Takeaways

1. **SRE é engenharia aplicada a operações** - não é apenas administração de sistemas
2. **SLOs e error budgets permitem balancear velocidade e confiabilidade**
3. **Toil deve ser eliminado através de automação**
4. **Postmortems blameless criam cultura de aprendizado**
5. **Observabilidade é fundamental - você não pode melhorar o que não mede**

## 🤔 Perguntas Frequentes

**P: SRE substitui DevOps?**  
R: Não, SRE é uma implementação específica de práticas DevOps com foco em confiabilidade.

**P: Preciso de um time dedicado de SRE?**  
R: Não necessariamente. Pode começar com práticas SRE incorporadas em times existentes.

**P: Qual a diferença entre SRE e Platform Engineering?**  
R: SRE foca em confiabilidade de serviços. Platform Engineering foca em criar plataformas self-service para desenvolvedores.

**P: Como começar com SRE em uma empresa pequena?**  
R: Comece com SLOs, monitoramento básico e automação de tarefas repetitivas.

---

**Next Steps**: 
- Leia [SLIs, SLOs e SLAs](slis-slos-slas.md)
- Explore [Error Budgets](error-budgets.md)
- Veja [Monitoramento e Observabilidade](../best-practices/monitoring-basics.md)
