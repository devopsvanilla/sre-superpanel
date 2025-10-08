#!/usr/bin/env bash
#
# SRE SuperPanel - Logging Utilities
# Funções de utilidade para logging padronizado
#

# Prevenir múltiplos carregamentos
[[ -n "${_SRE_LOGGING_LOADED}" ]] && return 0
_SRE_LOGGING_LOADED=1

# Cores para output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Níveis de log
readonly LOG_LEVEL_DEBUG=0
readonly LOG_LEVEL_INFO=1
readonly LOG_LEVEL_WARN=2
readonly LOG_LEVEL_ERROR=3

# Nível de log atual (padrão: INFO)
CURRENT_LOG_LEVEL=${LOG_LEVEL_INFO}

# Nível de log atual (padrão: INFO)
CURRENT_LOG_LEVEL=${LOG_LEVEL_INFO}

# Arquivo de log
LOG_FILE="${LOG_FILE:-/tmp/sre-superpanel.log}"

# Função para definir o nível de log
set_log_level() {
    case "${1}" in
        debug|DEBUG) CURRENT_LOG_LEVEL=${LOG_LEVEL_DEBUG} ;;
        info|INFO) CURRENT_LOG_LEVEL=${LOG_LEVEL_INFO} ;;
        warn|WARN) CURRENT_LOG_LEVEL=${LOG_LEVEL_WARN} ;;
        error|ERROR) CURRENT_LOG_LEVEL=${LOG_LEVEL_ERROR} ;;
        *) log_warn "Nível de log inválido: ${1}. Usando INFO." ;;
    esac
}

# Função auxiliar para log
_log() {
    local level=$1
    local color=$2
    local message=$3
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    echo -e "${color}[${timestamp}] [${level}] ${message}${NC}"
    echo "[${timestamp}] [${level}] ${message}" >> "${LOG_FILE}"
}

# Funções de log específicas
log_debug() {
    [[ ${CURRENT_LOG_LEVEL} -le ${LOG_LEVEL_DEBUG} ]] && _log "DEBUG" "${BLUE}" "$*"
}

log_info() {
    [[ ${CURRENT_LOG_LEVEL} -le ${LOG_LEVEL_INFO} ]] && _log "INFO" "${GREEN}" "$*"
}

log_warn() {
    [[ ${CURRENT_LOG_LEVEL} -le ${LOG_LEVEL_WARN} ]] && _log "WARN" "${YELLOW}" "$*"
}

log_error() {
    [[ ${CURRENT_LOG_LEVEL} -le ${LOG_LEVEL_ERROR} ]] && _log "ERROR" "${RED}" "$*" >&2
}

# Função para log de sucesso
log_success() {
    _log "SUCCESS" "${GREEN}" "✓ $*"
}

# Função para log de falha
log_fail() {
    _log "FAIL" "${RED}" "✗ $*" >&2
}

# Função para criar separador visual
log_separator() {
    echo ""
    echo "=================================================="
    echo ""
}

# Função para exibir banner
log_banner() {
    echo ""
    echo "=================================================="
    echo "  $*"
    echo "=================================================="
    echo ""
}
