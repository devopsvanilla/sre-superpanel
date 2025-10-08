# 📊 Dashboards

Esta pasta contém dashboards pré-configurados para diversas ferramentas de monitoramento e visualização.

## 📁 Estrutura

```
dashboards/
├── grafana/           # Dashboards Grafana
├── prometheus/        # Configurações Prometheus
└── README.md         # Este arquivo
```

## 🎯 Dashboards Disponíveis

### Grafana

Os dashboards Grafana estão organizados por tecnologia e caso de uso:

- **Infraestrutura**: Servidores, containers, orquestração
- **Aplicações**: Métricas de aplicação, performance
- **Bancos de Dados**: PostgreSQL, MySQL, MongoDB, Redis
- **Mensageria**: RabbitMQ, Kafka
- **Observabilidade**: Golden Signals, Error Budget

## 🚀 Como Usar

### Importar Dashboard no Grafana

1. Acesse seu Grafana
2. Vá em **Dashboards** → **Import**
3. Cole o conteúdo do arquivo JSON ou faça upload
4. Configure o datasource (Prometheus, InfluxDB, etc.)
5. Clique em **Import**

### Exemplo

```bash
# Copiar um dashboard
cp dashboards/grafana/[categoria]/[dashboard].json /tmp/

# Importar via API do Grafana (exemplo)
curl -X POST http://grafana:3000/api/dashboards/db \
  -H "Content-Type: application/json" \
  -d @/tmp/dashboard.json
```

## 📝 Estrutura de Dashboard

Cada dashboard deve incluir:

```
dashboards/grafana/[categoria]/
├── [nome-dashboard].json     # Dashboard Grafana
├── README.md                 # Documentação
└── screenshots/              # Capturas de tela (opcional)
    └── overview.png
```

### Documentação Requerida

Cada dashboard deve ter um README.md com:

- **Descrição**: O que o dashboard monitora
- **Pré-requisitos**: Datasources, métricas necessárias
- **Painéis Incluídos**: Lista de visualizações
- **Configuração**: Passos de configuração específicos
- **Alertas**: Alertas sugeridos (se aplicável)
- **Referências**: Links e documentação adicional

## 🔧 Personalizando Dashboards

### Variáveis

Dashboards usam variáveis para facilitar reutilização:

- `$datasource`: Fonte de dados
- `$namespace`: Namespace/ambiente
- `$interval`: Intervalo de atualização
- `$instance`: Instância específica

### Exemplo de Variável

```json
{
  "templating": {
    "list": [
      {
        "name": "datasource",
        "type": "datasource",
        "query": "prometheus"
      }
    ]
  }
}
```

## 📊 Categorias de Dashboards

### 1. Golden Signals
- Latência
- Tráfego
- Erros
- Saturação

### 2. Infrastructure
- CPU, Memória, Disco, Rede
- Containers e Pods
- Kubernetes Clusters

### 3. Applications
- Métricas de aplicação
- Traces distribuídos
- Business metrics

### 4. Databases
- Queries lentas
- Conexões
- Replicação
- Performance

## 🤝 Contribuindo

Para adicionar um novo dashboard:

1. Crie uma pasta na categoria apropriada
2. Adicione o arquivo JSON do dashboard
3. Crie um README.md descritivo
4. Adicione screenshots (opcional mas recomendado)
5. Teste o dashboard antes de submeter PR

### Template de README

```markdown
# [Nome do Dashboard]

## Descrição
[O que este dashboard monitora]

## Pré-requisitos
- Grafana >= X.X
- Datasource: [Prometheus/InfluxDB/etc]
- Métricas necessárias: [lista]

## Painéis
1. [Painel 1] - [descrição]
2. [Painel 2] - [descrição]

## Instalação
[Passos de instalação]

## Configuração
[Configurações específicas]

## Alertas
[Alertas sugeridos]
```

## 📚 Recursos

- [Grafana Documentation](https://grafana.com/docs/)
- [Prometheus Best Practices](https://prometheus.io/docs/practices/)
- [Dashboard Design Patterns](https://grafana.com/blog/2021/12/02/grafana-dashboards-a-complete-guide-to-all-the-different-types-you-can-build/)

## 🆘 Suporte

Problemas com dashboards? 

1. Verifique a documentação do dashboard
2. Confira os pré-requisitos
3. Abra uma issue no GitHub
4. Consulte a comunidade

---

**Dashboards bem projetados são essenciais para observabilidade efetiva!** 📊✨
