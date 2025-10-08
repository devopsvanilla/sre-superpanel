#!/usr/bin/env bash
#
# SRE SuperPanel - Terraform Wrapper
# Wrapper para orquestração do Terraform
#

# Prevenir múltiplos carregamentos
[[ -n "${_SRE_TERRAFORM_LOADED}" ]] && return 0
_SRE_TERRAFORM_LOADED=1

# Source utilities
_TOOLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${_TOOLS_DIR}/../lib/logging.sh"
source "${_TOOLS_DIR}/../lib/errors.sh"

# Função para inicializar Terraform
terraform_init() {
    local work_dir=${1:-.}
    
    log_info "Inicializando Terraform em ${work_dir}..."
    
    if ! command_exists terraform; then
        log_error "Terraform não está instalado"
        return 1
    fi
    
    (
        cd "${work_dir}" || return 1
        terraform init
    )
    
    check_exit_code $? "Inicialização do Terraform"
}

# Função para planejar infraestrutura
terraform_plan() {
    local work_dir=${1:-.}
    local var_file=${2:-""}
    local out_file=${3:-"tfplan"}
    
    log_info "Planejando infraestrutura com Terraform..."
    
    local cmd="terraform plan -out=${out_file}"
    
    if [[ -n "${var_file}" ]]; then
        cmd="${cmd} -var-file=${var_file}"
    fi
    
    (
        cd "${work_dir}" || return 1
        eval "${cmd}"
    )
    
    check_exit_code $? "Planejamento do Terraform"
}

# Função para aplicar infraestrutura
terraform_apply() {
    local work_dir=${1:-.}
    local plan_file=${2:-"tfplan"}
    local auto_approve=${3:-false}
    
    log_info "Aplicando infraestrutura com Terraform..."
    
    local cmd="terraform apply"
    
    if [[ "${auto_approve}" == "true" ]]; then
        cmd="${cmd} -auto-approve"
    fi
    
    if [[ -f "${work_dir}/${plan_file}" ]]; then
        cmd="${cmd} ${plan_file}"
    fi
    
    (
        cd "${work_dir}" || return 1
        eval "${cmd}"
    )
    
    check_exit_code $? "Aplicação do Terraform"
}

# Função para destruir infraestrutura
terraform_destroy() {
    local work_dir=${1:-.}
    local var_file=${2:-""}
    local auto_approve=${3:-false}
    
    log_warn "Destruindo infraestrutura com Terraform..."
    
    local cmd="terraform destroy"
    
    if [[ "${auto_approve}" == "true" ]]; then
        cmd="${cmd} -auto-approve"
    fi
    
    if [[ -n "${var_file}" ]]; then
        cmd="${cmd} -var-file=${var_file}"
    fi
    
    (
        cd "${work_dir}" || return 1
        eval "${cmd}"
    )
    
    check_exit_code $? "Destruição do Terraform"
}

# Função para validar configuração
terraform_validate() {
    local work_dir=${1:-.}
    
    log_info "Validando configuração do Terraform..."
    
    (
        cd "${work_dir}" || return 1
        terraform validate
    )
    
    check_exit_code $? "Validação do Terraform"
}

# Função para formatar código
terraform_fmt() {
    local work_dir=${1:-.}
    
    log_info "Formatando código Terraform..."
    
    (
        cd "${work_dir}" || return 1
        terraform fmt -recursive
    )
    
    check_exit_code $? "Formatação do Terraform"
}

# Exportar funções
export -f terraform_init
export -f terraform_plan
export -f terraform_apply
export -f terraform_destroy
export -f terraform_validate
export -f terraform_fmt
