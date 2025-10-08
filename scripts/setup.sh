#!/usr/bin/env bash
#
# SRE SuperPanel - Setup Script
# Script de instalação inicial do framework
#

set -e

# Cores
readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m'

# Banner
echo -e "${BLUE}"
cat << "EOF"
   _____ _____  ______    _____                       _____                  _ 
  / ____|  __ \|  ____|  / ____|                     |  __ \                | |
 | (___ | |__) | |__    | (___  _   _ _ __   ___ _ __| |__) |_ _ _ __   ___| |
  \___ \|  _  /|  __|    \___ \| | | | '_ \ / _ \ '__|  ___/ _` | '_ \ / _ \ |
  ____) | | \ \| |____   ____) | |_| | |_) |  __/ |  | |  | (_| | | | |  __/ |
 |_____/|_|  \_\______| |_____/ \__,_| .__/ \___|_|  |_|   \__,_|_| |_|\___|_|
                                     | |                                       
                                     |_|                                       
EOF
echo -e "${NC}"

echo -e "${GREEN}Framework de Orquestração para SRE${NC}"
echo ""

# Diretórios
INSTALL_DIR="${INSTALL_DIR:-/opt/sre-superpanel}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}==> Instalando SRE SuperPanel Framework...${NC}"
echo ""

# Função para verificar se comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Verificar dependências básicas
echo -e "${BLUE}==> Verificando dependências básicas...${NC}"

DEPENDENCIES=("bash" "git" "curl")

for dep in "${DEPENDENCIES[@]}"; do
    if command_exists "${dep}"; then
        echo -e "${GREEN}✓${NC} ${dep} encontrado"
    else
        echo -e "${YELLOW}✗${NC} ${dep} não encontrado"
        echo -e "${YELLOW}Por favor, instale ${dep} antes de continuar${NC}"
        exit 1
    fi
done

echo ""

# Perguntar sobre instalação local ou sistema
echo -e "${BLUE}Onde deseja instalar o framework?${NC}"
echo "1) Local (diretório atual)"
echo "2) Sistema (/opt/sre-superpanel)"
read -r -p "Escolha [1]: " install_choice
install_choice=${install_choice:-1}

if [[ "${install_choice}" == "2" ]]; then
    # Verificar permissões
    if [[ ! -w /opt ]]; then
        echo -e "${YELLOW}Requer permissões sudo para instalar em /opt${NC}"
        USE_SUDO="sudo"
    fi
    
    echo -e "${BLUE}==> Instalando em ${INSTALL_DIR}...${NC}"
    ${USE_SUDO} mkdir -p "${INSTALL_DIR}"
    ${USE_SUDO} cp -r "${SCRIPT_DIR}"/* "${INSTALL_DIR}/"
    ${USE_SUDO} chmod +x "${INSTALL_DIR}/orchestrator.sh"
    
    # Criar symlink
    ${USE_SUDO} ln -sf "${INSTALL_DIR}/orchestrator.sh" /usr/local/bin/sre-panel
    
    echo -e "${GREEN}✓ Framework instalado em ${INSTALL_DIR}${NC}"
    echo -e "${GREEN}✓ Comando 'sre-panel' disponível no sistema${NC}"
else
    # Instalação local
    INSTALL_DIR="${SCRIPT_DIR}"
    chmod +x "${INSTALL_DIR}/orchestrator.sh"
    
    echo -e "${GREEN}✓ Framework configurado no diretório atual${NC}"
    echo -e "${YELLOW}Execute com: ./scripts/orchestrator.sh${NC}"
fi

echo ""

# Criar estrutura de diretórios
echo -e "${BLUE}==> Criando estrutura de diretórios...${NC}"

mkdir -p "${INSTALL_DIR}/config"
mkdir -p "${INSTALL_DIR}/solutions"
mkdir -p "${INSTALL_DIR}/playbooks"
mkdir -p "${INSTALL_DIR}/terraform"

echo -e "${GREEN}✓ Estrutura criada${NC}"
echo ""

# Criar arquivo de configuração padrão
echo -e "${BLUE}==> Criando configuração padrão...${NC}"

cat > "${INSTALL_DIR}/config/default.conf" << 'EOF'
# SRE SuperPanel - Configuração Padrão

# Diretórios
SOLUTIONS_DIR="${INSTALL_DIR}/solutions"
PLAYBOOKS_DIR="${INSTALL_DIR}/playbooks"
TERRAFORM_DIR="${INSTALL_DIR}/terraform"

# Configurações de log
LOG_LEVEL="info"
LOG_FILE="/tmp/sre-superpanel.log"

# Timeout padrão (segundos)
DEFAULT_TIMEOUT=300

# Retry padrão
DEFAULT_RETRY_COUNT=3
DEFAULT_RETRY_DELAY=5
EOF

echo -e "${GREEN}✓ Configuração padrão criada${NC}"
echo ""

# Verificar dependências opcionais
echo -e "${BLUE}==> Verificando ferramentas opcionais...${NC}"

OPTIONAL_TOOLS=("terraform" "ansible" "docker" "kubectl" "python3" "node" "npm" "pip3")

for tool in "${OPTIONAL_TOOLS[@]}"; do
    if command_exists "${tool}"; then
        version=$(${tool} --version 2>/dev/null | head -1)
        echo -e "${GREEN}✓${NC} ${tool}: ${version}"
    else
        echo -e "${YELLOW}○${NC} ${tool}: não instalado (opcional)"
    fi
done

echo ""

# Resumo
echo -e "${GREEN}==> Instalação concluída!${NC}"
echo ""
echo -e "${BLUE}Próximos passos:${NC}"
echo ""

if [[ "${install_choice}" == "2" ]]; then
    echo "  1. Execute: sre-panel check"
    echo "  2. Inicialize: sre-panel init"
    echo "  3. Veja a ajuda: sre-panel --help"
else
    echo "  1. Execute: ./scripts/orchestrator.sh check"
    echo "  2. Inicialize: ./scripts/orchestrator.sh init"
    echo "  3. Veja a ajuda: ./scripts/orchestrator.sh --help"
fi

echo ""
echo -e "${BLUE}Documentação: https://github.com/devopsvanilla/sre-superpanel${NC}"
echo ""

exit 0
