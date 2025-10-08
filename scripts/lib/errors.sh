#!/usr/bin/env bash
#
# SRE SuperPanel - Error Handling
# Funções de tratamento de erros e validação
#

# Prevenir múltiplos carregamentos
[[ -n "${_SRE_ERRORS_LOADED}" ]] && return 0
_SRE_ERRORS_LOADED=1

# Source logging utilities
_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${_LIB_DIR}/logging.sh"

# Contador de erros
ERROR_COUNT=0

# Função de tratamento de erro global
error_handler() {
    local line_no=$1
    local bash_lineno=$2
    local exit_code=$3
    local command="$4"
    
    ((ERROR_COUNT++))
    
    log_error "Erro na linha ${line_no}: comando '${command}' falhou com código ${exit_code}"
    
    # Stack trace
    log_error "Stack trace:"
    local frame=0
    while caller $frame 2>/dev/null; do
        ((frame++))
    done | while read -r line func file; do
        log_error "  em ${func} (${file}:${line})"
    done
    
    return "${exit_code}"
}

# Função para validar parâmetros obrigatórios
require_param() {
    local param_name=$1
    local param_value=$2
    
    if [[ -z "${param_value}" ]]; then
        log_error "Parâmetro obrigatório não fornecido: ${param_name}"
        return 1
    fi
    
    return 0
}

# Função para validar arquivo existe
require_file() {
    local file_path=$1
    
    if [[ ! -f "${file_path}" ]]; then
        log_error "Arquivo não encontrado: ${file_path}"
        return 1
    fi
    
    return 0
}

# Função para validar diretório existe
require_directory() {
    local dir_path=$1
    
    if [[ ! -d "${dir_path}" ]]; then
        log_error "Diretório não encontrado: ${dir_path}"
        return 1
    fi
    
    return 0
}

# Função para validar permissão de execução
require_executable() {
    local file_path=$1
    
    if [[ ! -x "${file_path}" ]]; then
        log_error "Arquivo não executável: ${file_path}"
        return 1
    fi
    
    return 0
}

# Função para tentar executar comando com retry
retry_command() {
    local max_attempts=${1:-3}
    local delay=${2:-5}
    shift 2
    local command=("$@")
    local attempt=1
    
    while [[ ${attempt} -le ${max_attempts} ]]; do
        log_info "Tentativa ${attempt}/${max_attempts}: ${command[*]}"
        
        if "${command[@]}"; then
            log_success "Comando executado com sucesso"
            return 0
        fi
        
        if [[ ${attempt} -lt ${max_attempts} ]]; then
            log_warn "Falha na tentativa ${attempt}. Aguardando ${delay}s antes de tentar novamente..."
            sleep "${delay}"
        fi
        
        ((attempt++))
    done
    
    log_error "Comando falhou após ${max_attempts} tentativas: ${command[*]}"
    return 1
}

# Função para executar comando com timeout
run_with_timeout() {
    local timeout=$1
    shift
    local command=("$@")
    
    log_debug "Executando com timeout de ${timeout}s: ${command[*]}"
    
    timeout "${timeout}" "${command[@]}"
    local exit_code=$?
    
    if [[ ${exit_code} -eq 124 ]]; then
        log_error "Comando excedeu timeout de ${timeout}s: ${command[*]}"
        return 1
    fi
    
    return ${exit_code}
}

# Função para verificar código de saída
check_exit_code() {
    local exit_code=$1
    local message=${2:-"Operação"}
    
    if [[ ${exit_code} -eq 0 ]]; then
        log_success "${message} concluída com sucesso"
        return 0
    else
        log_error "${message} falhou com código ${exit_code}"
        return ${exit_code}
    fi
}

# Função para obter número total de erros
get_error_count() {
    echo "${ERROR_COUNT}"
}

# Função para resetar contador de erros
reset_error_count() {
    ERROR_COUNT=0
}

# Exportar funções
export -f error_handler
export -f require_param
export -f require_file
export -f require_directory
export -f require_executable
export -f retry_command
export -f run_with_timeout
export -f check_exit_code
export -f get_error_count
export -f reset_error_count
