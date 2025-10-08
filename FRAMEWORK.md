# SRE SuperPanel - Framework de Orquestração em Bash

## 📝 Resumo do Projeto

Framework completo em Bash para orquestração de ferramentas de provisionamento, configuração e instalação de soluções de monitoramento e infraestrutura.

## 🎯 Objetivo

Criar um "super padrão" que consolida as melhores práticas, padrões e iniciativas existentes em observabilidade e SRE, oferecendo curadoria e direcionamento para diversos casos de uso.

## ✨ Funcionalidades Implementadas

### 1. **Core Framework**
- ✅ Script principal de orquestração (`orchestrator.sh`)
- ✅ Script de instalação/setup (`setup.sh`)
- ✅ Sistema modular e extensível

### 2. **Bibliotecas Principais** (`scripts/lib/`)

#### `logging.sh` - Sistema de Logging
- Logging colorido e padronizado
- Múltiplos níveis: DEBUG, INFO, WARN, ERROR
- Funções: `log_info()`, `log_success()`, `log_warn()`, `log_error()`, `log_debug()`
- Banners e separadores visuais
- Log em arquivo automático

#### `dependencies.sh` - Verificação de Dependências
- Detecção automática de ferramentas instaladas
- Verificação de versões
- Suporte para: terraform, ansible, docker, kubectl, helm, python, pip, node, npm, git, jq, yq
- Categorização: básicas, provisionamento, linguagens

#### `config.sh` - Gerenciamento de Configuração
- Carregamento de configurações padrão e do usuário
- Persistência de configurações
- Validação de parâmetros obrigatórios
- Arquivo de configuração em `/scripts/config/`

#### `errors.sh` - Tratamento de Erros
- Validação de parâmetros obrigatórios
- Verificação de arquivos e diretórios
- Retry automático com delay configurável
- Timeout para comandos
- Stack trace de erros

### 3. **Wrappers de Ferramentas** (`scripts/tools/`)

#### `terraform.sh` - Orquestração Terraform
- `terraform_init()` - Inicialização
- `terraform_plan()` - Planejamento
- `terraform_apply()` - Aplicação
- `terraform_destroy()` - Destruição
- `terraform_validate()` - Validação
- `terraform_fmt()` - Formatação

#### `ansible.sh` - Orquestração Ansible
- `ansible_playbook()` - Executar playbooks
- `ansible_adhoc()` - Comandos ad-hoc
- `ansible_inventory()` - Verificar inventário
- `ansible_ping()` - Testar conectividade
- `ansible_gather_facts()` - Coletar fatos
- `ansible_syntax_check()` - Validação de sintaxe

#### `packages.sh` - Gerenciadores de Pacotes
**APT (Debian/Ubuntu):**
- `apt_update()` - Atualizar repositórios
- `apt_install()` - Instalar pacotes
- `apt_upgrade()` - Upgrade de pacotes

**NPM (Node.js):**
- `npm_install_global()` - Instalação global
- `npm_install()` - Instalação local
- `npm_ci()` - Instalação limpa
- `npm_update()` - Atualização

**PIP (Python):**
- `pip_install()` - Instalar pacotes
- `pip_install_requirements()` - Instalar de requirements.txt
- `pip_upgrade()` - Atualizar pacotes
- `create_venv()` - Criar ambiente virtual

**Docker:**
- `docker_build()` - Build de imagens
- `docker_run()` - Executar containers

### 4. **Sistema de Soluções** (`scripts/solutions/`)

Estrutura para criar soluções instaláveis:
- `install.sh` - Script de instalação
- `configure.sh` - Script de configuração
- `status.sh` - Script de verificação de status

**Exemplo Incluído:** `example-monitoring`
- Demonstração de instalação de stack de monitoramento
- Configuração de Prometheus, Grafana e AlertManager
- Verificação de status dos componentes

## 🚀 Comandos Disponíveis

### Principais
```bash
./scripts/orchestrator.sh check              # Verificar dependências
./scripts/orchestrator.sh init               # Inicializar ambiente
./scripts/orchestrator.sh install <solução>  # Instalar solução
./scripts/orchestrator.sh configure <solução># Configurar solução
./scripts/orchestrator.sh status             # Verificar status
./scripts/orchestrator.sh version            # Exibir versão
```

### Opções
```bash
--help              # Ajuda
--verbose           # Modo debug
--log-level LEVEL   # Definir nível de log
--config FILE       # Usar config específico
```

## 📁 Estrutura de Arquivos

```
sre-superpanel/
├── .gitignore
├── LICENSE
├── README.md
└── scripts/
    ├── orchestrator.sh          # Script principal
    ├── setup.sh                 # Script de instalação
    ├── lib/                     # Bibliotecas
    │   ├── logging.sh          # Logging
    │   ├── dependencies.sh     # Dependências
    │   ├── config.sh           # Configuração
    │   └── errors.sh           # Erros
    ├── tools/                   # Wrappers
    │   ├── terraform.sh        # Terraform
    │   ├── ansible.sh          # Ansible
    │   └── packages.sh         # Pacotes
    ├── solutions/               # Soluções
    │   └── example-monitoring/ # Exemplo
    │       ├── install.sh
    │       ├── configure.sh
    │       └── status.sh
    ├── config/                  # Configurações
    │   ├── default.conf
    │   └── user.conf
    ├── playbooks/              # Playbooks Ansible
    └── terraform/              # Módulos Terraform
```

## 🧪 Testes Realizados

✅ Comando `--help` - Exibe ajuda completa
✅ Comando `version` - Exibe versão do framework
✅ Comando `check` - Verifica todas as dependências
✅ Comando `init` - Inicializa o ambiente
✅ Comando `install example-monitoring` - Instala solução de exemplo
✅ Comando `configure example-monitoring` - Configura solução
✅ Comando `status` - Exibe status das soluções
✅ Script `setup.sh` - Instalação do framework

## 🔧 Como Usar

### 1. Instalação
```bash
git clone https://github.com/devopsvanilla/sre-superpanel.git
cd sre-superpanel
./scripts/setup.sh
```

### 2. Verificar Dependências
```bash
./scripts/orchestrator.sh check
```

### 3. Inicializar
```bash
./scripts/orchestrator.sh init
```

### 4. Instalar Solução
```bash
./scripts/orchestrator.sh install example-monitoring
```

### 5. Configurar
```bash
./scripts/orchestrator.sh configure example-monitoring
```

### 6. Verificar Status
```bash
./scripts/orchestrator.sh status
```

## 🎨 Características Técnicas

### Segurança
- Prevenção de múltiplos carregamentos de bibliotecas
- Variáveis readonly para constantes
- Validação de parâmetros obrigatórios
- Verificação de arquivos e diretórios

### Robustez
- Retry automático em falhas
- Timeout configurável
- Logging detalhado
- Stack trace de erros
- Check de código de saída

### Extensibilidade
- Sistema modular
- Fácil adição de novas soluções
- Wrappers reutilizáveis
- Configuração flexível

### Usabilidade
- Output colorido
- Mensagens claras
- Documentação completa
- Exemplos práticos
- Modo verboso/debug

## 📚 Próximos Passos

### Roadmap Sugerido
1. Adicionar mais soluções de monitoramento (Prometheus completo, ELK Stack)
2. Integração com Kubernetes (kubectl, helm)
3. Templates de dashboards
4. Biblioteca de runbooks
5. Indicadores SLI/SLO
6. Automação de alertas
7. CI/CD integrado
8. Testes automatizados

### Como Adicionar Nova Solução
```bash
# 1. Criar diretório
mkdir -p scripts/solutions/minha-solucao

# 2. Criar install.sh
cat > scripts/solutions/minha-solucao/install.sh << 'EOF'
#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../lib/logging.sh"

log_banner "Instalando Minha Solução"
# Sua lógica aqui
log_success "Instalação concluída!"
EOF

# 3. Tornar executável
chmod +x scripts/solutions/minha-solucao/install.sh

# 4. Usar
./scripts/orchestrator.sh install minha-solucao
```

## 📝 Licença

MIT License - Copyright (c) 2025 Sandro Cicero

## 🤝 Contribuições

Contribuições são bem-vindas! Este é um projeto de código aberto para a comunidade SRE.

---

**Framework desenvolvido para o projeto SRE SuperPanel**
**https://github.com/devopsvanilla/sre-superpanel**
