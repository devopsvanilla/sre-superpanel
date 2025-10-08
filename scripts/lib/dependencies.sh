#!/usr/bin/env bash
#
# SRE SuperPanel - Dependency Checker
# Verificação de dependências e ferramentas necessárias
#

# Prevenir múltiplos carregamentos
[[ -n "${_SRE_DEPENDENCIES_LOADED}" ]] && return 0
_SRE_DEPENDENCIES_LOADED=1

# Source logging utilities
_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${_LIB_DIR}/logging.sh"

# Lista de ferramentas suportadas
declare -A TOOL_VERSIONS

# Função para verificar se um comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Função para obter versão de uma ferramenta
get_tool_version() {
    local tool=$1
    local version=""
    
    case "${tool}" in
        terraform)
            version=$(terraform version -json 2>/dev/null | grep -oP '"terraform_version":\s*"\K[^"]+' || terraform version 2>/dev/null | head -1 | awk '{print $2}' | tr -d 'v')
            ;;
        ansible)
            version=$(ansible --version 2>/dev/null | head -1 | awk '{print $2}' | tr -d '[]')
            ;;
        docker)
            version=$(docker --version 2>/dev/null | awk '{print $3}' | tr -d ',')
            ;;
        kubectl)
            version=$(kubectl version --client --short 2>/dev/null | awk '{print $3}' | tr -d 'v')
            ;;
        helm)
            version=$(helm version --short 2>/dev/null | awk '{print $1}' | tr -d 'v')
            ;;
        python|python3)
            version=$(python3 --version 2>/dev/null | awk '{print $2}')
            ;;
        pip|pip3)
            version=$(pip3 --version 2>/dev/null | awk '{print $2}')
            ;;
        node)
            version=$(node --version 2>/dev/null | tr -d 'v')
            ;;
        npm)
            version=$(npm --version 2>/dev/null)
            ;;
        git)
            version=$(git --version 2>/dev/null | awk '{print $3}')
            ;;
        jq)
            version=$(jq --version 2>/dev/null | tr -d 'jq-')
            ;;
        yq)
            version=$(yq --version 2>/dev/null | awk '{print $3}')
            ;;
        *)
            version=$($tool --version 2>/dev/null | head -1)
            ;;
    esac
    
    echo "${version}"
}

# Função para verificar uma ferramenta
check_tool() {
    local tool=$1
    local required=${2:-false}
    
    if command_exists "${tool}"; then
        local version
        version=$(get_tool_version "${tool}")
        TOOL_VERSIONS["${tool}"]="${version}"
        log_success "${tool} encontrado (versão: ${version})"
        return 0
    else
        if [[ "${required}" == "true" ]]; then
            log_error "${tool} não encontrado (obrigatório)"
            return 1
        else
            log_warn "${tool} não encontrado (opcional)"
            return 0
        fi
    fi
}

# Função para verificar múltiplas ferramentas
check_tools() {
    local tools=("$@")
    local all_found=true
    
    log_banner "Verificando Dependências"
    
    for tool in "${tools[@]}"; do
        if ! check_tool "${tool}"; then
            all_found=false
        fi
    done
    
    log_separator
    
    if [[ "${all_found}" == "true" ]]; then
        log_success "Todas as dependências obrigatórias foram encontradas"
        return 0
    else
        log_error "Algumas dependências obrigatórias estão faltando"
        return 1
    fi
}

# Função para verificar dependências de sistema
check_system_dependencies() {
    log_info "Verificando dependências do sistema..."
    
    # Ferramentas básicas (obrigatórias)
    local basic_tools=("bash" "curl" "wget" "git")
    
    for tool in "${basic_tools[@]}"; do
        check_tool "${tool}" "true" || return 1
    done
    
    # Ferramentas opcionais
    local optional_tools=("jq" "yq")
    
    for tool in "${optional_tools[@]}"; do
        check_tool "${tool}" "false"
    done
    
    return 0
}

# Função para verificar dependências de provisionamento
check_provisioning_dependencies() {
    log_info "Verificando ferramentas de provisionamento..."
    
    local provisioning_tools=("terraform" "ansible" "docker")
    
    for tool in "${provisioning_tools[@]}"; do
        check_tool "${tool}" "false"
    done
}

# Função para verificar dependências de linguagens
check_language_dependencies() {
    log_info "Verificando ambientes de linguagem..."
    
    local language_tools=("python3" "pip3" "node" "npm")
    
    for tool in "${language_tools[@]}"; do
        check_tool "${tool}" "false"
    done
}

# Função principal de verificação
check_all_dependencies() {
    log_banner "SRE SuperPanel - Verificação de Dependências"
    
    check_system_dependencies || return 1
    check_provisioning_dependencies
    check_language_dependencies
    
    log_separator
    log_success "Verificação de dependências concluída"
    
    # Exibir resumo
    log_info "Ferramentas disponíveis:"
    for tool in "${!TOOL_VERSIONS[@]}"; do
        log_info "  - ${tool}: ${TOOL_VERSIONS[$tool]}"
    done
    
    return 0
}

# Exportar funções
export -f command_exists
export -f get_tool_version
export -f check_tool
export -f check_tools
export -f check_system_dependencies
export -f check_provisioning_dependencies
export -f check_language_dependencies
export -f check_all_dependencies
