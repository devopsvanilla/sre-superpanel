# 📝 Receitas e Runbooks

Esta pasta contém receitas práticas, runbooks e procedimentos operacionais para cenários comuns de SRE.

## 📁 Estrutura

```
recipes/
├── troubleshooting/    # Guias de resolução de problemas
├── automation/         # Scripts e automações
├── incident-response/  # Procedimentos de resposta a incidentes
├── deployment/         # Procedimentos de deploy
└── README.md          # Este arquivo
```

## 🎯 O que são Receitas?

Receitas são guias passo a passo para realizar tarefas operacionais específicas. Incluem:

- **Runbooks**: Procedimentos para responder a alertas e incidentes
- **Troubleshooting Guides**: Guias de diagnóstico e resolução
- **Automation Scripts**: Scripts para tarefas repetitivas
- **Deployment Procedures**: Procedimentos de deploy seguros

## 📚 Categorias

### 🔍 Troubleshooting

Guias para diagnosticar e resolver problemas comuns:

- Alta latência
- Erros de aplicação
- Problemas de rede
- Issues de banco de dados
- Problemas de memória/CPU
- Falhas de containers

### 🤖 Automation

Scripts e procedimentos automatizados:

- Health checks
- Backup e restore
- Scaling automático
- Limpeza de recursos
- Rotação de credenciais

### 🚨 Incident Response

Procedimentos para resposta a incidentes:

- Incident triage
- Escalation procedures
- Communication templates
- Post-mortem templates
- War room procedures

### 🚀 Deployment

Procedimentos de deploy seguro:

- Blue-green deployment
- Canary releases
- Rollback procedures
- Database migrations
- Feature flags

## 📖 Como Usar uma Receita

### 1. Identificar o Problema

```bash
# Listar receitas disponíveis
ls recipes/troubleshooting/

# Buscar por palavra-chave
grep -r "high latency" recipes/
```

### 2. Seguir o Runbook

Cada receita segue uma estrutura padrão:

1. **Problema**: Descrição do cenário
2. **Sintomas**: Como identificar
3. **Diagnóstico**: Passos de investigação
4. **Solução**: Passos de resolução
5. **Prevenção**: Como evitar no futuro

### 3. Adaptar ao Contexto

Receitas são templates - adapte para seu ambiente:
- Ajuste comandos para suas ferramentas
- Modifique thresholds conforme necessário
- Adicione passos específicos do seu sistema

## 📝 Template de Receita

```markdown
# [Nome da Receita]

## 📋 Visão Geral

**Problema**: [Descrição breve do problema]
**Severidade**: [Crítica/Alta/Média/Baixa]
**Tempo Estimado**: [Tempo para resolver]

## 🎯 Quando Usar

Use esta receita quando:
- [Sintoma 1]
- [Sintoma 2]
- [Sintoma 3]

## ⚠️ Pré-requisitos

- [Acesso/permissão necessária]
- [Ferramenta necessária]
- [Conhecimento necessário]

## 🔍 Diagnóstico

### Passo 1: Verificar [Componente]

```bash
# Comando de verificação
[comando]
```

**Saída Esperada**: [descrição]
**Se diferente**: [próximo passo]

### Passo 2: Investigar [Aspecto]

[Instruções detalhadas]

## 🛠️ Solução

### Opção 1: [Nome da Solução]

**Quando usar**: [cenário]

```bash
# Comandos
[passos]
```

### Opção 2: [Nome da Solução Alternativa]

**Quando usar**: [cenário alternativo]

## ✅ Verificação

Como confirmar que o problema foi resolvido:

1. [Verificação 1]
2. [Verificação 2]

```bash
# Comandos de verificação
[comandos]
```

## 🚫 Rollback

Se a solução causar problemas:

```bash
# Comandos de rollback
[passos para reverter]
```

## 📊 Monitoramento

Métricas para acompanhar após a resolução:
- [Métrica 1]
- [Métrica 2]

## 🔄 Prevenção

Como evitar este problema no futuro:
- [Ação preventiva 1]
- [Ação preventiva 2]

## 📚 Referências

- [Link 1]
- [Link 2]
- [Documentação relevante]

## 📝 Histórico de Uso

| Data | Usuário | Resultado | Notas |
|------|---------|-----------|-------|
| YYYY-MM-DD | @user | Sucesso | [observações] |
```

## 🔥 Receitas Essenciais

### 1. Alta Latência HTTP

```bash
# Ver receita
cat recipes/troubleshooting/http-high-latency.md
```

### 2. Out of Memory (OOM)

```bash
# Ver receita
cat recipes/troubleshooting/oom-issues.md
```

### 3. Database Connection Pool Exhausted

```bash
# Ver receita
cat recipes/troubleshooting/db-connection-pool.md
```

### 4. Kubernetes Pod CrashLoopBackOff

```bash
# Ver receita
cat recipes/troubleshooting/k8s-crashloop.md
```

## 🤖 Scripts de Automação

### Estrutura de Script

```bash
#!/bin/bash
# Nome: [nome-do-script]
# Descrição: [o que faz]
# Autor: [nome]
# Versão: 1.0

set -euo pipefail

# Configuração
PARAM1="${1:-default}"

# Funções
function check_prerequisites() {
    # Verificar pré-requisitos
}

function main() {
    check_prerequisites
    # Lógica principal
}

# Executar
main "$@"
```

### Boas Práticas

- Use `set -euo pipefail` para segurança
- Valide inputs
- Log de ações importantes
- Dry-run mode quando possível
- Documentar no script

## 📋 Runbook de Incidentes

### Template de Incident Response

```markdown
# Incident: [Título]

## Detalhes
- **Data/Hora**: [timestamp]
- **Severidade**: [SEV1/SEV2/SEV3]
- **Impacto**: [descrição]
- **Status**: [Em andamento/Resolvido]

## Timeline

| Hora | Ação | Responsável |
|------|------|-------------|
| HH:MM | [ação] | @user |

## Ações Tomadas

1. [Ação 1]
2. [Ação 2]

## Root Cause

[Descrição da causa raiz]

## Remediação

[O que foi feito para resolver]

## Action Items

- [ ] [Ação 1] - @responsável - [prazo]
- [ ] [Ação 2] - @responsável - [prazo]

## Lessons Learned

[O que aprendemos]
```

## 🤝 Contribuindo

Para adicionar uma nova receita:

1. **Escolha a categoria apropriada**
2. **Use o template padrão**
3. **Teste a receita em ambiente real**
4. **Documente edge cases**
5. **Adicione exemplos práticos**

### Checklist

- [ ] Título claro e descritivo
- [ ] Problema bem definido
- [ ] Passos reproduzíveis
- [ ] Comandos validados
- [ ] Verificação incluída
- [ ] Rollback documentado
- [ ] Prevenção sugerida

## 📊 Métricas de Receitas

Acompanhe efetividade das receitas:

- **MTTR** (Mean Time To Repair): Tempo médio usando a receita
- **Success Rate**: Taxa de sucesso
- **Usage**: Frequência de uso
- **Feedback**: Comentários da equipe

## 📖 Recursos

- [Google SRE Book - Incident Response](https://sre.google/sre-book/managing-incidents/)
- [Runbook Template Examples](https://github.com/SkeltonThatcher/run-book-template)
- [PagerDuty Incident Response](https://response.pagerduty.com/)
- [Atlassian Incident Management](https://www.atlassian.com/incident-management)

## 🆘 Suporte

Precisa de ajuda com receitas?

1. Revise exemplos existentes
2. Consulte a documentação
3. Abra uma issue
4. Compartilhe feedback

---

**Boas receitas reduzem MTTR e aumentam confiabilidade!** 📝✨
