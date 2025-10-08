#!/usr/bin/env bash
#
# Example Monitoring Solution - Configure Script
# Script de exemplo de configuração de uma solução de monitoramento
#

# Source das bibliotecas
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../lib/logging.sh"
source "${SCRIPT_DIR}/../../lib/config.sh"

# Função principal de configuração
configure_monitoring() {
    log_banner "Configurando Solução de Monitoramento"
    
    # Configurar parâmetros
    log_info "Definindo configurações..."
    
    set_config "PROMETHEUS_PORT" "9090"
    set_config "GRAFANA_PORT" "3000"
    set_config "ALERTMANAGER_PORT" "9093"
    
    # Salvar configuração
    save_user_config
    
    log_separator
    log_success "Solução configurada com sucesso!"
    
    # Exibir configuração
    show_config
    
    return 0
}

# Executar configuração
configure_monitoring
exit $?
