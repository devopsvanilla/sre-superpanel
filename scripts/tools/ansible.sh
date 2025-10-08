#!/usr/bin/env bash
#
# SRE SuperPanel - Ansible Wrapper
# Wrapper para orquestração do Ansible
#

# Prevenir múltiplos carregamentos
[[ -n "${_SRE_ANSIBLE_LOADED}" ]] && return 0
_SRE_ANSIBLE_LOADED=1

# Source utilities
_TOOLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${_TOOLS_DIR}/../lib/logging.sh"
source "${_TOOLS_DIR}/../lib/errors.sh"

# Função para executar playbook
ansible_playbook() {
    local playbook_file=$1
    local inventory=${2:-"inventory"}
    local extra_vars=${3:-""}
    local tags=${4:-""}
    
    log_info "Executando Ansible playbook: ${playbook_file}..."
    
    if ! command_exists ansible-playbook; then
        log_error "Ansible não está instalado"
        return 1
    fi
    
    require_file "${playbook_file}" || return 1
    
    local cmd="ansible-playbook ${playbook_file} -i ${inventory}"
    
    if [[ -n "${extra_vars}" ]]; then
        cmd="${cmd} -e '${extra_vars}'"
    fi
    
    if [[ -n "${tags}" ]]; then
        cmd="${cmd} --tags ${tags}"
    fi
    
    eval "${cmd}"
    
    check_exit_code $? "Execução do Ansible playbook"
}

# Função para executar comando ad-hoc
ansible_adhoc() {
    local hosts=$1
    local module=${2:-"ping"}
    local args=${3:-""}
    local inventory=${4:-"inventory"}
    
    log_info "Executando comando Ansible ad-hoc no grupo ${hosts}..."
    
    local cmd="ansible ${hosts} -i ${inventory} -m ${module}"
    
    if [[ -n "${args}" ]]; then
        cmd="${cmd} -a '${args}'"
    fi
    
    eval "${cmd}"
    
    check_exit_code $? "Comando Ansible ad-hoc"
}

# Função para verificar inventário
ansible_inventory() {
    local inventory=${1:-"inventory"}
    local host=${2:-""}
    
    log_info "Verificando inventário Ansible..."
    
    local cmd="ansible-inventory -i ${inventory}"
    
    if [[ -n "${host}" ]]; then
        cmd="${cmd} --host ${host}"
    else
        cmd="${cmd} --list"
    fi
    
    eval "${cmd}"
    
    check_exit_code $? "Verificação do inventário Ansible"
}

# Função para testar conectividade
ansible_ping() {
    local hosts=${1:-"all"}
    local inventory=${2:-"inventory"}
    
    log_info "Testando conectividade com hosts: ${hosts}..."
    
    ansible "${hosts}" -i "${inventory}" -m ping
    
    check_exit_code $? "Teste de conectividade Ansible"
}

# Função para coletar fatos
ansible_gather_facts() {
    local hosts=${1:-"all"}
    local inventory=${2:-"inventory"}
    local output_file=${3:-""}
    
    log_info "Coletando fatos dos hosts: ${hosts}..."
    
    local cmd="ansible ${hosts} -i ${inventory} -m setup"
    
    if [[ -n "${output_file}" ]]; then
        cmd="${cmd} > ${output_file}"
    fi
    
    eval "${cmd}"
    
    check_exit_code $? "Coleta de fatos Ansible"
}

# Função para validar playbook
ansible_syntax_check() {
    local playbook_file=$1
    
    log_info "Validando sintaxe do playbook: ${playbook_file}..."
    
    require_file "${playbook_file}" || return 1
    
    ansible-playbook "${playbook_file}" --syntax-check
    
    check_exit_code $? "Validação de sintaxe do Ansible"
}

# Exportar funções
export -f ansible_playbook
export -f ansible_adhoc
export -f ansible_inventory
export -f ansible_ping
export -f ansible_gather_facts
export -f ansible_syntax_check
