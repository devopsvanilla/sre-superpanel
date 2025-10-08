#!/usr/bin/env bash
#
# Example Monitoring Solution - Status Script
# Script de exemplo para verificar status de uma solução
#

# Source das bibliotecas
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../lib/logging.sh"

# Função para verificar status
check_status() {
    log_info "Verificando status dos componentes..."
    
    # Simular verificação de serviços
    log_info "Prometheus: ativo (porta 9090)"
    log_info "Grafana: ativo (porta 3000)"
    log_info "AlertManager: ativo (porta 9093)"
    
    log_success "Todos os componentes estão funcionando"
    
    return 0
}

# Executar verificação
check_status
exit $?
