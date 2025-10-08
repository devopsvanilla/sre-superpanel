# SRE SuperPanel

Stack open source MIT para monitoramento de sistemas e infraestrutura. Inclui painéis, indicadores, receitas e base de conhecimento para SREs, com curadoria de boas práticas e padrões consolidados para diversos casos de uso.

## 📋 Sobre o Projeto

SRE SuperPanel é um "super padrão" que consolida as melhores práticas, padrões e iniciativas existentes em observabilidade e SRE, oferecendo curadoria e direcionamento para diversos casos de uso. O projeto fornece um framework completo em Bash para orquestrar ferramentas de provisionamento, configuração e instalação.

## 🚀 Framework de Orquestração

O framework em Bash permite orquestrar ferramentas como:
- **Terraform** - Provisionamento de infraestrutura
- **Ansible** - Configuração e automação
- **Docker** - Containerização
- **Gerenciadores de pacotes** - apt, npm, pip, etc.

### Características

- ✅ Logging padronizado e colorido
- ✅ Verificação automática de dependências
- ✅ Gerenciamento de configuração
- ✅ Tratamento robusto de erros
- ✅ Wrappers para ferramentas de provisionamento
- ✅ Sistema modular e extensível
- ✅ Retry automático e timeout
- ✅ Suporte a múltiplas soluções

## 📦 Instalação

### Instalação Rápida

```bash
# Clonar o repositório
git clone https://github.com/devopsvanilla/sre-superpanel.git
cd sre-superpanel

# Executar setup
chmod +x scripts/setup.sh
./scripts/setup.sh
```

### Opções de Instalação

**Instalação Local** (no diretório atual):
```bash
./scripts/setup.sh
# Escolher opção 1
```

**Instalação no Sistema** (/opt/sre-superpanel):
```bash
./scripts/setup.sh
# Escolher opção 2
# Requer sudo
```

## 🎯 Uso

### Comandos Principais

```bash
# Verificar dependências
./scripts/orchestrator.sh check

# Inicializar ambiente
./scripts/orchestrator.sh init

# Instalar uma solução
./scripts/orchestrator.sh install example-monitoring

# Configurar uma solução
./scripts/orchestrator.sh configure example-monitoring

# Verificar status
./scripts/orchestrator.sh status

# Exibir versão
./scripts/orchestrator.sh version

# Ajuda
./scripts/orchestrator.sh --help
```

### Modo Verboso

```bash
# Executar com debug
./scripts/orchestrator.sh --verbose check

# Definir nível de log
./scripts/orchestrator.sh --log-level debug init
```

### Usar Configuração Customizada

```bash
./scripts/orchestrator.sh --config /path/to/config.conf install solution
```

## 🏗️ Estrutura do Projeto

```
sre-superpanel/
├── scripts/
│   ├── orchestrator.sh          # Script principal
│   ├── setup.sh                 # Script de instalação
│   ├── lib/                     # Bibliotecas
│   │   ├── logging.sh          # Utilitários de log
│   │   ├── errors.sh           # Tratamento de erros
│   │   ├── dependencies.sh     # Verificação de dependências
│   │   └── config.sh           # Gerenciamento de config
│   ├── tools/                   # Wrappers de ferramentas
│   │   ├── terraform.sh        # Wrapper do Terraform
│   │   ├── ansible.sh          # Wrapper do Ansible
│   │   └── packages.sh         # Gerenciadores de pacotes
│   ├── solutions/               # Soluções instaláveis
│   │   └── example-monitoring/ # Exemplo de solução
│   ├── config/                  # Configurações
│   ├── playbooks/              # Playbooks Ansible
│   └── terraform/              # Módulos Terraform
├── LICENSE
└── README.md
```

## 🔧 Desenvolvimento de Soluções

### Criar Nova Solução

1. Criar diretório da solução:
```bash
mkdir -p scripts/solutions/minha-solucao
```

2. Criar script de instalação (`install.sh`):
```bash
#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../lib/logging.sh"
source "${SCRIPT_DIR}/../../lib/errors.sh"

log_banner "Instalando Minha Solução"
# Lógica de instalação aqui
log_success "Instalação concluída!"
```

3. Criar script de configuração (`configure.sh`):
```bash
#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../lib/logging.sh"
source "${SCRIPT_DIR}/../../lib/config.sh"

log_banner "Configurando Minha Solução"
# Lógica de configuração aqui
log_success "Configuração concluída!"
```

4. Criar script de status (`status.sh`):
```bash
#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../lib/logging.sh"

log_info "Status: Ativo"
```

### Usar Bibliotecas

```bash
# Importar bibliotecas
source "${SCRIPT_DIR}/../../lib/logging.sh"
source "${SCRIPT_DIR}/../../lib/errors.sh"
source "${SCRIPT_DIR}/../../lib/dependencies.sh"
source "${SCRIPT_DIR}/../../tools/terraform.sh"
source "${SCRIPT_DIR}/../../tools/ansible.sh"
source "${SCRIPT_DIR}/../../tools/packages.sh"

# Usar funções de log
log_info "Mensagem informativa"
log_success "Operação bem-sucedida"
log_warn "Aviso"
log_error "Erro"

# Verificar ferramentas
check_tool "docker" "true"  # Obrigatório
check_tool "kubectl" "false" # Opcional

# Instalar pacotes
apt_install "curl" "wget" "jq"
npm_install_global "pm2" "typescript"
pip_install "ansible" "boto3"

# Usar Terraform
terraform_init "./terraform"
terraform_plan "./terraform" "vars.tfvars"
terraform_apply "./terraform" "tfplan" "true"

# Usar Ansible
ansible_playbook "deploy.yml" "inventory" "env=prod"
ansible_ping "all" "inventory"
```

## 📚 Bibliotecas Disponíveis

### logging.sh
- `log_info()` - Log informativo
- `log_success()` - Log de sucesso
- `log_warn()` - Log de aviso
- `log_error()` - Log de erro
- `log_debug()` - Log de debug
- `log_banner()` - Banner com título
- `log_separator()` - Separador visual
- `set_log_level()` - Definir nível de log

### errors.sh
- `require_param()` - Validar parâmetro obrigatório
- `require_file()` - Validar arquivo existe
- `require_directory()` - Validar diretório existe
- `retry_command()` - Executar comando com retry
- `run_with_timeout()` - Executar com timeout
- `check_exit_code()` - Verificar código de saída

### dependencies.sh
- `command_exists()` - Verificar se comando existe
- `get_tool_version()` - Obter versão de ferramenta
- `check_tool()` - Verificar ferramenta específica
- `check_all_dependencies()` - Verificar todas dependências

### config.sh
- `load_config()` - Carregar configurações
- `get_config()` - Obter valor de config
- `set_config()` - Definir valor de config
- `save_user_config()` - Salvar configuração
- `validate_config()` - Validar configuração

## 🛠️ Wrappers de Ferramentas

### Terraform (terraform.sh)
- `terraform_init()` - Inicializar Terraform
- `terraform_plan()` - Planejar infraestrutura
- `terraform_apply()` - Aplicar infraestrutura
- `terraform_destroy()` - Destruir infraestrutura
- `terraform_validate()` - Validar configuração
- `terraform_fmt()` - Formatar código

### Ansible (ansible.sh)
- `ansible_playbook()` - Executar playbook
- `ansible_adhoc()` - Comando ad-hoc
- `ansible_ping()` - Testar conectividade
- `ansible_gather_facts()` - Coletar fatos
- `ansible_syntax_check()` - Validar sintaxe

### Packages (packages.sh)
- `apt_install()` - Instalar via apt
- `npm_install()` - Instalar via npm
- `pip_install()` - Instalar via pip
- `docker_build()` - Build Docker
- `docker_run()` - Executar container

## 🤝 Contribuindo

Contribuições são bem-vindas! Este projeto visa ser um "super padrão" colaborativo para a comunidade SRE.

### Como Contribuir

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-solucao`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova solução'`)
4. Push para a branch (`git push origin feature/nova-solucao`)
5. Abra um Pull Request

### Áreas de Contribuição

- 📊 Novas soluções de monitoramento
- 🔧 Melhorias no framework
- 📖 Documentação e exemplos
- 🧪 Testes e validações
- 🎨 Dashboards e painéis
- 📚 Base de conhecimento SRE

## 📄 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 🌟 Roadmap

- [ ] Adicionar mais soluções de monitoramento (Prometheus, Grafana, ELK)
- [ ] Integração com Kubernetes
- [ ] Templates de dashboards
- [ ] Biblioteca de runbooks
- [ ] Indicadores SLI/SLO
- [ ] Automação de alertas
- [ ] CI/CD integrado
- [ ] Testes automatizados

## 📞 Suporte

- 📫 Issues: [GitHub Issues](https://github.com/devopsvanilla/sre-superpanel/issues)
- 📖 Documentação: [Wiki](https://github.com/devopsvanilla/sre-superpanel/wiki)
- 💬 Discussões: [GitHub Discussions](https://github.com/devopsvanilla/sre-superpanel/discussions)

---

**Desenvolvido com ❤️ pela comunidade SRE**
