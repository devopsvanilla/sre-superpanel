#!/usr/bin/env bash
#
# SRE SuperPanel - Package Manager Wrapper
# Wrapper para gerenciadores de pacotes (apt, npm, pip)
#

# Prevenir múltiplos carregamentos
[[ -n "${_SRE_PACKAGES_LOADED}" ]] && return 0
_SRE_PACKAGES_LOADED=1

# Source utilities
_TOOLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${_TOOLS_DIR}/../lib/logging.sh"
source "${_TOOLS_DIR}/../lib/errors.sh"

# ============================================
# APT (Debian/Ubuntu)
# ============================================

# Função para atualizar repositórios APT
apt_update() {
    log_info "Atualizando repositórios APT..."
    
    if ! command_exists apt-get; then
        log_warn "APT não está disponível neste sistema"
        return 1
    fi
    
    sudo apt-get update -y
    
    check_exit_code $? "Atualização de repositórios APT"
}

# Função para instalar pacotes APT
apt_install() {
    local packages=("$@")
    
    log_info "Instalando pacotes APT: ${packages[*]}..."
    
    sudo apt-get install -y "${packages[@]}"
    
    check_exit_code $? "Instalação de pacotes APT"
}

# Função para fazer upgrade de pacotes APT
apt_upgrade() {
    log_info "Atualizando pacotes instalados via APT..."
    
    sudo apt-get upgrade -y
    
    check_exit_code $? "Upgrade de pacotes APT"
}

# ============================================
# NPM (Node Package Manager)
# ============================================

# Função para instalar pacotes NPM globalmente
npm_install_global() {
    local packages=("$@")
    
    log_info "Instalando pacotes NPM globalmente: ${packages[*]}..."
    
    if ! command_exists npm; then
        log_error "NPM não está instalado"
        return 1
    fi
    
    npm install -g "${packages[@]}"
    
    check_exit_code $? "Instalação global de pacotes NPM"
}

# Função para instalar pacotes NPM localmente
npm_install() {
    local packages=("$@")
    
    log_info "Instalando pacotes NPM: ${packages[*]}..."
    
    npm install "${packages[@]}"
    
    check_exit_code $? "Instalação de pacotes NPM"
}

# Função para instalar dependências do projeto
npm_ci() {
    log_info "Instalando dependências do projeto com npm ci..."
    
    npm ci
    
    check_exit_code $? "Instalação de dependências NPM"
}

# Função para atualizar pacotes NPM
npm_update() {
    log_info "Atualizando pacotes NPM..."
    
    npm update
    
    check_exit_code $? "Atualização de pacotes NPM"
}

# ============================================
# PIP (Python Package Manager)
# ============================================

# Função para instalar pacotes PIP
pip_install() {
    local packages=("$@")
    
    log_info "Instalando pacotes PIP: ${packages[*]}..."
    
    if ! command_exists pip3; then
        log_error "PIP não está instalado"
        return 1
    fi
    
    pip3 install "${packages[@]}"
    
    check_exit_code $? "Instalação de pacotes PIP"
}

# Função para instalar pacotes de requirements.txt
pip_install_requirements() {
    local requirements_file=${1:-"requirements.txt"}
    
    log_info "Instalando pacotes do arquivo ${requirements_file}..."
    
    require_file "${requirements_file}" || return 1
    
    pip3 install -r "${requirements_file}"
    
    check_exit_code $? "Instalação de requirements PIP"
}

# Função para atualizar pacote PIP
pip_upgrade() {
    local packages=("$@")
    
    log_info "Atualizando pacotes PIP: ${packages[*]}..."
    
    pip3 install --upgrade "${packages[@]}"
    
    check_exit_code $? "Atualização de pacotes PIP"
}

# Função para criar ambiente virtual Python
create_venv() {
    local venv_dir=${1:-"venv"}
    
    log_info "Criando ambiente virtual Python em ${venv_dir}..."
    
    python3 -m venv "${venv_dir}"
    
    check_exit_code $? "Criação de ambiente virtual"
}

# ============================================
# Docker
# ============================================

# Função para construir imagem Docker
docker_build() {
    local dockerfile=${1:-"Dockerfile"}
    local image_name=$2
    local context=${3:-.}
    
    log_info "Construindo imagem Docker: ${image_name}..."
    
    if ! command_exists docker; then
        log_error "Docker não está instalado"
        return 1
    fi
    
    require_file "${dockerfile}" || return 1
    
    docker build -f "${dockerfile}" -t "${image_name}" "${context}"
    
    check_exit_code $? "Build da imagem Docker"
}

# Função para executar container Docker
docker_run() {
    local image_name=$1
    shift
    local args=("$@")
    
    log_info "Executando container Docker: ${image_name}..."
    
    docker run "${args[@]}" "${image_name}"
    
    check_exit_code $? "Execução de container Docker"
}

# Exportar funções
export -f apt_update
export -f apt_install
export -f apt_upgrade
export -f npm_install_global
export -f npm_install
export -f npm_ci
export -f npm_update
export -f pip_install
export -f pip_install_requirements
export -f pip_upgrade
export -f create_venv
export -f docker_build
export -f docker_run
