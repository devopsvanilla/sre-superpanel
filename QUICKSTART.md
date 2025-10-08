# Guia de Início Rápido - SRE SuperPanel

## 🚀 Instalação em 3 Passos

### Passo 1: Clonar o Repositório
```bash
git clone https://github.com/devopsvanilla/sre-superpanel.git
cd sre-superpanel
```

### Passo 2: Executar Setup
```bash
chmod +x scripts/setup.sh
./scripts/setup.sh
```

Escolha a opção de instalação:
- **Opção 1**: Instalação local (diretório atual)
- **Opção 2**: Instalação no sistema (`/opt/sre-superpanel` - requer sudo)

### Passo 3: Verificar Instalação
```bash
# Para instalação local
./scripts/orchestrator.sh check

# Para instalação no sistema
sre-panel check
```

## 📋 Comandos Essenciais

### Verificar Dependências
```bash
./scripts/orchestrator.sh check
```

### Inicializar Ambiente
```bash
./scripts/orchestrator.sh init
```

### Listar Soluções Disponíveis
```bash
ls scripts/solutions/
```

### Instalar uma Solução
```bash
./scripts/orchestrator.sh install example-monitoring
```

### Configurar uma Solução
```bash
./scripts/orchestrator.sh configure example-monitoring
```

### Verificar Status
```bash
./scripts/orchestrator.sh status
```

### Modo Debug/Verboso
```bash
./scripts/orchestrator.sh --verbose check
```

## 🔨 Criar Sua Primeira Solução

### 1. Criar Estrutura
```bash
mkdir -p scripts/solutions/minha-primeira-solucao
cd scripts/solutions/minha-primeira-solucao
```

### 2. Criar install.sh
```bash
cat > install.sh << 'EOF'
#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../lib/logging.sh"
source "${SCRIPT_DIR}/../../lib/errors.sh"
source "${SCRIPT_DIR}/../../lib/dependencies.sh"

log_banner "Instalando Minha Primeira Solução"

# Verificar dependências
log_info "Verificando dependências..."
check_tool "docker" "true" || exit 1

# Sua lógica de instalação aqui
log_info "Executando instalação..."
sleep 2

log_success "Instalação concluída com sucesso!"
EOF

chmod +x install.sh
```

### 3. Criar configure.sh
```bash
cat > configure.sh << 'EOF'
#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../lib/logging.sh"
source "${SCRIPT_DIR}/../../lib/config.sh"

log_banner "Configurando Minha Primeira Solução"

# Definir configurações
set_config "MINHA_CONFIG" "valor123"
save_user_config

log_success "Configuração concluída!"
show_config
EOF

chmod +x configure.sh
```

### 4. Criar status.sh
```bash
cat > status.sh << 'EOF'
#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../lib/logging.sh"

log_info "Status: Ativo e funcionando!"
EOF

chmod +x status.sh
```

### 5. Testar
```bash
cd ../../..
./scripts/orchestrator.sh install minha-primeira-solucao
./scripts/orchestrator.sh configure minha-primeira-solucao
./scripts/orchestrator.sh status
```

## 🎯 Exemplos de Uso das Bibliotecas

### Logging
```bash
source "${SCRIPT_DIR}/../../lib/logging.sh"

log_info "Mensagem informativa"
log_success "Operação bem-sucedida"
log_warn "Aviso importante"
log_error "Erro encontrado"
log_debug "Informação de debug"
log_banner "Título da Seção"
log_separator
```

### Verificação de Dependências
```bash
source "${SCRIPT_DIR}/../../lib/dependencies.sh"

# Verificar ferramenta
check_tool "docker" "true"  # obrigatória
check_tool "kubectl" "false" # opcional

# Verificar se comando existe
if command_exists "terraform"; then
    echo "Terraform está instalado"
fi
```

### Gestão de Pacotes
```bash
source "${SCRIPT_DIR}/../../tools/packages.sh"

# APT
apt_update
apt_install "curl" "wget" "jq"

# NPM
npm_install_global "pm2"
npm_install "express"

# PIP
pip_install "ansible" "boto3"
create_venv "venv"
```

### Terraform
```bash
source "${SCRIPT_DIR}/../../tools/terraform.sh"

terraform_init "./terraform"
terraform_plan "./terraform" "vars.tfvars" "plan.out"
terraform_apply "./terraform" "plan.out" "true"
```

### Ansible
```bash
source "${SCRIPT_DIR}/../../tools/ansible.sh"

ansible_playbook "deploy.yml" "inventory" "env=prod"
ansible_ping "all" "inventory"
```

### Tratamento de Erros
```bash
source "${SCRIPT_DIR}/../../lib/errors.sh"

# Validar parâmetros
require_param "NOME" "${NOME}" || exit 1
require_file "/path/to/file" || exit 1

# Retry automático
retry_command 3 5 curl https://api.example.com

# Timeout
run_with_timeout 30 ./script-lento.sh
```

## 📖 Documentação Adicional

- [README.md](README.md) - Documentação completa
- [FRAMEWORK.md](FRAMEWORK.md) - Detalhes técnicos do framework
- [LICENSE](LICENSE) - Licença MIT

## 🆘 Solução de Problemas

### Erro: "comando não encontrado"
```bash
# Certifique-se de que o script tem permissão de execução
chmod +x scripts/orchestrator.sh
```

### Erro: "dependência não encontrada"
```bash
# Verifique as dependências
./scripts/orchestrator.sh check

# Instale as ferramentas necessárias
sudo apt update
sudo apt install curl wget git
```

### Modo Debug
```bash
# Execute com log detalhado
./scripts/orchestrator.sh --log-level debug --verbose check
```

## 🌟 Dicas Úteis

1. **Use tab completion**: Configure autocompletion para bash
2. **Crie aliases**: `alias sre='./scripts/orchestrator.sh'`
3. **Configure log**: Defina `LOG_FILE` para mudar localização do log
4. **Modo verboso**: Use `--verbose` para debug detalhado
5. **Configuração custom**: Use `--config` para arquivo de config específico

## 🔗 Links Úteis

- Repositório: https://github.com/devopsvanilla/sre-superpanel
- Issues: https://github.com/devopsvanilla/sre-superpanel/issues
- Discussões: https://github.com/devopsvanilla/sre-superpanel/discussions

---

**Comece agora e contribua com a comunidade SRE!** 🚀
