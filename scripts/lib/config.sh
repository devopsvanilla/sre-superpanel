#!/usr/bin/env bash
#
# SRE SuperPanel - Configuration Manager
# Gerenciamento de configurações do projeto
#

# Prevenir múltiplos carregamentos
[[ -n "${_SRE_CONFIG_LOADED}" ]] && return 0
_SRE_CONFIG_LOADED=1

# Source logging utilities
_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${_LIB_DIR}/logging.sh"

# Diretório de configurações
CONFIG_DIR="${CONFIG_DIR:-${_LIB_DIR}/../config}"
DEFAULT_CONFIG_FILE="${CONFIG_DIR}/default.conf"
USER_CONFIG_FILE="${CONFIG_DIR}/user.conf"

# Variáveis de configuração globais
declare -A CONFIG

# Função para carregar configuração padrão
load_default_config() {
    if [[ -f "${DEFAULT_CONFIG_FILE}" ]]; then
        log_debug "Carregando configuração padrão de ${DEFAULT_CONFIG_FILE}"
        source "${DEFAULT_CONFIG_FILE}"
        return 0
    else
        log_debug "Arquivo de configuração padrão não encontrado"
        return 1
    fi
}

# Função para carregar configuração do usuário
load_user_config() {
    if [[ -f "${USER_CONFIG_FILE}" ]]; then
        log_debug "Carregando configuração do usuário de ${USER_CONFIG_FILE}"
        source "${USER_CONFIG_FILE}"
        return 0
    else
        log_debug "Arquivo de configuração do usuário não encontrado"
        return 1
    fi
}

# Função para carregar todas as configurações
load_config() {
    log_info "Carregando configurações..."
    
    load_default_config
    load_user_config
    
    log_success "Configurações carregadas"
    return 0
}

# Função para obter valor de configuração
get_config() {
    local key=$1
    local default_value=${2:-""}
    
    if [[ -n "${CONFIG[$key]}" ]]; then
        echo "${CONFIG[$key]}"
    else
        echo "${default_value}"
    fi
}

# Função para definir valor de configuração
set_config() {
    local key=$1
    local value=$2
    
    CONFIG["${key}"]="${value}"
    log_debug "Configuração definida: ${key}=${value}"
}

# Função para salvar configuração do usuário
save_user_config() {
    log_info "Salvando configuração do usuário..."
    
    mkdir -p "${CONFIG_DIR}"
    
    {
        echo "# SRE SuperPanel - Configuração do Usuário"
        echo "# Gerado em: $(date '+%Y-%m-%d %H:%M:%S')"
        echo ""
        
        for key in "${!CONFIG[@]}"; do
            echo "${key}=\"${CONFIG[$key]}\""
        done
    } > "${USER_CONFIG_FILE}"
    
    log_success "Configuração salva em ${USER_CONFIG_FILE}"
    return 0
}

# Função para exibir configuração atual
show_config() {
    log_banner "Configuração Atual"
    
    if [[ ${#CONFIG[@]} -eq 0 ]]; then
        log_info "Nenhuma configuração definida"
    else
        for key in "${!CONFIG[@]}"; do
            log_info "${key} = ${CONFIG[$key]}"
        done
    fi
    
    log_separator
}

# Função para validar configuração
validate_config() {
    local required_keys=("$@")
    local valid=true
    
    log_info "Validando configuração..."
    
    for key in "${required_keys[@]}"; do
        if [[ -z "${CONFIG[$key]}" ]]; then
            log_error "Configuração obrigatória não definida: ${key}"
            valid=false
        fi
    done
    
    if [[ "${valid}" == "true" ]]; then
        log_success "Configuração válida"
        return 0
    else
        log_error "Configuração inválida"
        return 1
    fi
}

# Exportar funções
export -f load_default_config
export -f load_user_config
export -f load_config
export -f get_config
export -f set_config
export -f save_user_config
export -f show_config
export -f validate_config
