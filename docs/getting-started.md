# 🚀 Guia de Início Rápido

Bem-vindo ao SRE SuperPanel! Este guia vai ajudá-lo a começar a utilizar os recursos disponíveis no projeto.

## 📋 Pré-requisitos

Antes de começar, certifique-se de ter:

- Git instalado
- Acesso ao seu ambiente de monitoramento (Grafana, Prometheus, etc.)
- Conhecimentos básicos de SRE e monitoramento

## 🎯 Primeiros Passos

### 1. Clone o Repositório

```bash
git clone https://github.com/devopsvanilla/sre-superpanel.git
cd sre-superpanel
```

### 2. Explore a Estrutura

```bash
# Ver todos os recursos disponíveis
ls -la

# Explorar dashboards
cd dashboards
ls -la

# Explorar receitas
cd ../recipes
ls -la

# Explorar base de conhecimento
cd ../knowledge-base
ls -la
```

## 📊 Utilizando Dashboards

### Grafana

1. Navegue até `dashboards/grafana/`
2. Escolha o dashboard apropriado para seu caso de uso
3. Importe no Grafana:
   - Acesse Grafana > Dashboards > Import
   - Cole o conteúdo do arquivo JSON
   - Configure o datasource
   - Salve o dashboard

### Exemplo Prático

```bash
# Ver dashboards disponíveis
ls dashboards/grafana/

# Ler documentação de um dashboard específico
cat dashboards/grafana/[nome-do-dashboard]/README.md
```

## 📈 Configurando Indicadores

### SLIs (Service Level Indicators)

1. Navegue até `indicators/slis/`
2. Escolha os indicadores relevantes para seu serviço
3. Configure-os no seu sistema de monitoramento

### SLOs (Service Level Objectives)

1. Navegue até `indicators/slos/`
2. Revise os objetivos sugeridos
3. Adapte aos requisitos do seu negócio

### Exemplo

```bash
# Ver SLIs disponíveis
ls indicators/slis/

# Ver SLOs disponíveis
ls indicators/slos/
```

## 📝 Usando Receitas

### Runbooks

1. Navegue até `recipes/troubleshooting/`
2. Encontre a receita relevante para seu problema
3. Siga os passos documentados

### Automação

1. Navegue até `recipes/automation/`
2. Escolha os scripts/procedimentos úteis
3. Adapte para seu ambiente

### Exemplo de Uso

```bash
# Listar receitas de troubleshooting
ls recipes/troubleshooting/

# Ver uma receita específica
cat recipes/troubleshooting/[nome-da-receita].md
```

## 📚 Consultando a Base de Conhecimento

### Conceitos Fundamentais

```bash
# Explorar conceitos SRE
cd knowledge-base/concepts/
ls -la
```

### Melhores Práticas

```bash
# Ver melhores práticas
cd knowledge-base/best-practices/
ls -la
```

## 🛠️ Cenários Comuns

### Cenário 1: Monitorar um Cluster Kubernetes

1. Importe o dashboard Kubernetes do `dashboards/grafana/`
2. Configure SLIs de disponibilidade de pods
3. Defina SLOs baseados nos requisitos do negócio
4. Tenha runbooks prontos em `recipes/troubleshooting/kubernetes/`

### Cenário 2: Monitorar Aplicação Web

1. Use dashboards de golden signals (latência, tráfego, erros, saturação)
2. Configure alertas baseados em SLOs
3. Prepare runbooks de resposta a incidentes

### Cenário 3: Implementar Observabilidade

1. Consulte `knowledge-base/concepts/observability.md`
2. Implemente métricas, logs e traces
3. Use dashboards de correlação de sinais

## 🔧 Personalização

### Adaptando Dashboards

Os dashboards são templates. Para personalizar:

1. Abra o arquivo JSON
2. Ajuste queries para suas métricas
3. Modifique thresholds conforme necessário
4. Personalize cores e visualizações

### Adaptando SLOs

Os SLOs são sugestões baseadas em práticas da indústria:

1. Revise os valores propostos
2. Ajuste baseado em requisitos do negócio
3. Considere o erro budget
4. Documente suas decisões

## 📖 Recursos Adicionais

### Documentação

- [README Principal](../README.md)
- [Guia de Contribuição](../CONTRIBUTING.md)
- [Código de Conduta](../CODE_OF_CONDUCT.md)

### Comunidade

- Reporte problemas nas [GitHub Issues](https://github.com/devopsvanilla/sre-superpanel/issues)
- Contribua com melhorias via Pull Requests
- Compartilhe seus casos de uso

## ❓ Problemas Comuns

### Dashboard não carrega métricas
- Verifique se o datasource está configurado corretamente
- Confirme que as métricas existem no Prometheus/datasource
- Ajuste os nomes das métricas se necessário

### SLO não é atingível
- Revise os thresholds
- Considere o contexto do seu negócio
- Ajuste gradualmente baseado em dados históricos

### Receita não funciona no meu ambiente
- Adapte para suas ferramentas específicas
- Verifique pré-requisitos
- Contribua com melhorias para casos específicos

## 🚀 Próximos Passos

1. ⭐ Dê uma estrela no repositório se foi útil
2. 🤝 Contribua com seus próprios dashboards e receitas
3. 📢 Compartilhe com a comunidade SRE
4. 💡 Sugira melhorias e novos recursos

---

**Precisa de ajuda? Abra uma issue no GitHub!**
