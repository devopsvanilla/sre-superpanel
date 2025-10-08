#!/usr/bin/env bash
#
# SRE SuperPanel - Main Orchestrator
# Script principal para orquestração de instalação e configuração
#

# Desabilitar modo strict para permitir falhas controladas
set +e

# Definir diretórios
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="${SCRIPT_DIR}/lib"
TOOLS_DIR="${SCRIPT_DIR}/tools"
CONFIG_DIR="${SCRIPT_DIR}/config"

# Source das bibliotecas principais
source "${LIB_DIR}/logging.sh"
source "${LIB_DIR}/errors.sh"
source "${LIB_DIR}/dependencies.sh"
source "${LIB_DIR}/config.sh"

# Source dos wrappers de ferramentas
source "${TOOLS_DIR}/terraform.sh"
source "${TOOLS_DIR}/ansible.sh"
source "${TOOLS_DIR}/packages.sh"

# Versão do framework
readonly VERSION="1.0.0"

# Função de ajuda
show_help() {
    cat << EOF
SRE SuperPanel - Framework de Orquestração v${VERSION}

Uso: $(basename "$0") [OPÇÕES] COMANDO [ARGS]

COMANDOS:
    init                    Inicializar o ambiente
    check                   Verificar dependências
    install <solution>      Instalar uma solução
    configure <solution>    Configurar uma solução
    status                  Verificar status das soluções
    version                 Exibir versão do framework

OPÇÕES:
    -h, --help             Exibir esta mensagem de ajuda
    -v, --verbose          Modo verboso (debug)
    -c, --config FILE      Usar arquivo de configuração específico
    -l, --log-level LEVEL  Definir nível de log (debug|info|warn|error)

EXEMPLOS:
    $(basename "$0") check
    $(basename "$0") init
    $(basename "$0") install monitoring-stack
    $(basename "$0") --verbose configure prometheus

Para mais informações, visite: https://github.com/devopsvanilla/sre-superpanel
EOF
}

# Função para exibir versão
show_version() {
    echo "SRE SuperPanel Framework v${VERSION}"
}

# Função de inicialização
initialize() {
    log_banner "SRE SuperPanel - Inicialização"
    
    # Criar diretórios necessários
    log_info "Criando estrutura de diretórios..."
    mkdir -p "${CONFIG_DIR}"
    mkdir -p "${SCRIPT_DIR}/solutions"
    mkdir -p "${SCRIPT_DIR}/playbooks"
    mkdir -p "${SCRIPT_DIR}/terraform"
    
    # Carregar configurações
    load_config
    
    # Verificar dependências básicas
    check_system_dependencies || {
        log_error "Falha na verificação de dependências básicas"
        return 1
    }
    
    log_success "Inicialização concluída com sucesso"
    return 0
}

# Função para instalar solução
install_solution() {
    local solution_name=$1
    
    require_param "solution_name" "${solution_name}" || return 1
    
    log_banner "Instalando Solução: ${solution_name}"
    
    local solution_script="${SCRIPT_DIR}/solutions/${solution_name}/install.sh"
    
    if [[ -f "${solution_script}" ]]; then
        log_info "Executando script de instalação..."
        bash "${solution_script}"
        check_exit_code $? "Instalação de ${solution_name}"
    else
        log_error "Solução não encontrada: ${solution_name}"
        log_info "Script esperado em: ${solution_script}"
        return 1
    fi
}

# Função para configurar solução
configure_solution() {
    local solution_name=$1
    
    require_param "solution_name" "${solution_name}" || return 1
    
    log_banner "Configurando Solução: ${solution_name}"
    
    local solution_script="${SCRIPT_DIR}/solutions/${solution_name}/configure.sh"
    
    if [[ -f "${solution_script}" ]]; then
        log_info "Executando script de configuração..."
        bash "${solution_script}"
        check_exit_code $? "Configuração de ${solution_name}"
    else
        log_error "Script de configuração não encontrado: ${solution_name}"
        log_info "Script esperado em: ${solution_script}"
        return 1
    fi
}

# Função para verificar status
check_status() {
    log_banner "Status das Soluções"
    
    local solutions_dir="${SCRIPT_DIR}/solutions"
    
    if [[ -d "${solutions_dir}" ]]; then
        for solution_dir in "${solutions_dir}"/*; do
            if [[ -d "${solution_dir}" ]]; then
                local solution_name=$(basename "${solution_dir}")
                local status_script="${solution_dir}/status.sh"
                
                log_separator
                log_info "Solução: ${solution_name}"
                
                if [[ -f "${status_script}" ]]; then
                    bash "${status_script}"
                else
                    log_warn "Script de status não encontrado"
                fi
            fi
        done
    else
        log_info "Nenhuma solução instalada"
    fi
    
    log_separator
}

# Parser de argumentos
parse_args() {
    # Opções padrão
    local verbose=false
    local log_level="info"
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -v|--verbose)
                verbose=true
                log_level="debug"
                shift
                ;;
            -l|--log-level)
                log_level="$2"
                shift 2
                ;;
            -c|--config)
                USER_CONFIG_FILE="$2"
                shift 2
                ;;
            version)
                show_version
                exit 0
                ;;
            init)
                set_log_level "${log_level}"
                initialize
                exit $?
                ;;
            check)
                set_log_level "${log_level}"
                check_all_dependencies
                exit $?
                ;;
            install)
                set_log_level "${log_level}"
                install_solution "$2"
                exit $?
                ;;
            configure)
                set_log_level "${log_level}"
                configure_solution "$2"
                exit $?
                ;;
            status)
                set_log_level "${log_level}"
                check_status
                exit $?
                ;;
            *)
                log_error "Comando desconhecido: $1"
                echo ""
                show_help
                exit 1
                ;;
        esac
    done
    
    # Se não houver argumentos, mostrar ajuda
    show_help
    exit 0
}

# Main
main() {
    # Verificar se há argumentos
    if [[ $# -eq 0 ]]; then
        show_help
        exit 0
    fi
    
    parse_args "$@"
}

# Executar main
main "$@"
