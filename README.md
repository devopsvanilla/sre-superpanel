# 🚀 SRE SuperPanel

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

Stack open source MIT para monitoramento de sistemas e infraestrutura de TI. Inclui painéis, indicadores, receitas e base de conhecimento para SREs, com curadoria de boas práticas e padrões consolidados para diversos casos de uso.

## 📋 Índice

- [Sobre o Projeto](#sobre-o-projeto)
- [Recursos](#recursos)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Como Começar](#como-começar)
- [Como Contribuir](#como-contribuir)
- [Licença](#licença)

## 🎯 Sobre o Projeto

O **SRE SuperPanel** é uma coleção abrangente de recursos para Site Reliability Engineers (SREs) e equipes de operações de TI. Este projeto oferece:

- **Painéis de Monitoramento**: Dashboards prontos para uso com Grafana, Prometheus e outras ferramentas
- **Indicadores**: Métricas e SLIs (Service Level Indicators) curados para diferentes casos de uso
- **Receitas**: Guias passo a passo e runbooks para cenários comuns de operação
- **Base de Conhecimento**: Documentação, melhores práticas e padrões consolidados

## ✨ Recursos

### 📊 Painéis (Dashboards)
- Painéis pré-configurados para Grafana
- Templates para diferentes tecnologias e stacks
- Visualizações otimizadas para observabilidade

### 📈 Indicadores
- SLIs e SLOs para serviços comuns
- Métricas de golden signals (latência, tráfego, erros, saturação)
- KPIs operacionais

### 📝 Receitas
- Runbooks para incidentes comuns
- Procedimentos de troubleshooting
- Guias de automação e scripts

### 📚 Base de Conhecimento
- Conceitos fundamentais de SRE
- Melhores práticas da indústria
- Padrões de arquitetura para confiabilidade

## 📁 Estrutura do Projeto

```
sre-superpanel/
├── dashboards/          # Painéis de monitoramento
│   ├── grafana/        # Dashboards Grafana
│   └── README.md
├── indicators/          # Indicadores e métricas
│   ├── slis/           # Service Level Indicators
│   ├── slos/           # Service Level Objectives
│   └── README.md
├── recipes/            # Receitas e runbooks
│   ├── troubleshooting/
│   ├── automation/
│   └── README.md
├── knowledge-base/     # Base de conhecimento
│   ├── concepts/       # Conceitos fundamentais
│   ├── best-practices/ # Melhores práticas
│   └── README.md
└── docs/              # Documentação geral
    └── getting-started.md
```

## 🚀 Como Começar

### Pré-requisitos

Dependendo do que você deseja utilizar, pode precisar de:
- Grafana (para dashboards)
- Prometheus (para métricas)
- Docker (para exemplos containerizados)

### Instalação Rápida

1. Clone o repositório:
```bash
git clone https://github.com/devopsvanilla/sre-superpanel.git
cd sre-superpanel
```

2. Explore os recursos disponíveis:
```bash
# Ver dashboards disponíveis
ls dashboards/

# Ver receitas disponíveis
ls recipes/

# Ver base de conhecimento
ls knowledge-base/
```

3. Consulte a [documentação de início rápido](docs/getting-started.md) para instruções detalhadas.

## 🤝 Como Contribuir

Contribuições são muito bem-vindas! Este projeto foi criado para ser colaborativo e crescer com a comunidade de SREs.

### Formas de Contribuir

- ⭐ Adicionar novos dashboards
- 📊 Compartilhar indicadores e SLOs
- 📝 Contribuir com receitas e runbooks
- 📚 Melhorar a base de conhecimento
- 🐛 Reportar bugs e problemas
- 💡 Sugerir novos recursos

### Processo de Contribuição

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/MinhaContribuicao`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova receita de troubleshooting'`)
4. Push para a branch (`git push origin feature/MinhaContribuicao`)
5. Abra um Pull Request

Consulte [CONTRIBUTING.md](CONTRIBUTING.md) para diretrizes detalhadas.

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

**Desenvolvido com ❤️ pela comunidade SRE**

Se este projeto foi útil para você, considere dar uma ⭐!
