# Guia de Contribuição - SRE SuperPanel

Obrigado por considerar contribuir com o SRE SuperPanel! 🎉

## 📋 Como Contribuir

### 1. Fork e Clone
```bash
# Fork o repositório no GitHub
# Clone seu fork
git clone https://github.com/SEU-USUARIO/sre-superpanel.git
cd sre-superpanel

# Adicione o upstream
git remote add upstream https://github.com/devopsvanilla/sre-superpanel.git
```

### 2. Crie uma Branch
```bash
git checkout -b feature/minha-contribuicao
```

### 3. Faça suas Alterações
- Siga os padrões de código existentes
- Adicione documentação quando necessário
- Teste suas alterações

### 4. Commit e Push
```bash
git add .
git commit -m "Adiciona: descrição da contribuição"
git push origin feature/minha-contribuicao
```

### 5. Abra um Pull Request
- Descreva suas alterações
- Referencie issues relacionadas
- Aguarde review

## 🎯 Tipos de Contribuição

### 🐛 Reportar Bugs
Abra uma issue com:
- Descrição clara do problema
- Passos para reproduzir
- Comportamento esperado vs. atual
- Ambiente (SO, versões das ferramentas)

### ✨ Sugerir Features
Abra uma issue descrevendo:
- Caso de uso
- Benefícios
- Possível implementação

### 📝 Melhorar Documentação
- Corrigir typos
- Adicionar exemplos
- Traduzir conteúdo
- Escrever tutoriais

### 🔧 Adicionar Soluções
Crie novas soluções seguindo a estrutura:
```
scripts/solutions/nome-da-solucao/
├── install.sh      # Script de instalação
├── configure.sh    # Script de configuração
├── status.sh       # Script de verificação
└── README.md       # Documentação da solução
```

### 🛠️ Melhorar Framework
- Adicionar novas bibliotecas
- Melhorar wrappers existentes
- Otimizar performance
- Adicionar testes

## 📐 Padrões de Código

### Bash Script
```bash
#!/usr/bin/env bash
#
# Nome do Script
# Breve descrição
#

# Prevenir múltiplos carregamentos (para bibliotecas)
[[ -n "${_NOME_LOADED}" ]] && return 0
_NOME_LOADED=1

# Imports
source "${SCRIPT_DIR}/../../lib/logging.sh"

# Funções
funcao_exemplo() {
    local param1=$1
    local param2=${2:-"default"}
    
    log_info "Executando função..."
    
    # Lógica aqui
    
    return 0
}

# Exportar funções (se necessário)
export -f funcao_exemplo
```

### Naming Conventions
- **Variáveis**: `UPPER_CASE` para constantes, `lower_case` para variáveis locais
- **Funções**: `snake_case`
- **Arquivos**: `kebab-case.sh`

### Comentários
```bash
# Comentário de linha única

# Comentário de bloco
# que abrange múltiplas
# linhas de explicação
```

### Logging
Use sempre as funções de log:
```bash
log_info "Informação"
log_success "Sucesso"
log_warn "Aviso"
log_error "Erro"
log_debug "Debug"
```

### Tratamento de Erros
```bash
# Validar parâmetros
require_param "nome" "${nome}" || return 1

# Verificar arquivos
require_file "/path/file" || return 1

# Check de exit code
comando
check_exit_code $? "Descrição da operação"
```

## 🧪 Testes

### Testar Localmente
```bash
# 1. Verificar sintaxe
bash -n scripts/seu-script.sh

# 2. Executar script
./scripts/orchestrator.sh install sua-solucao

# 3. Testar em modo verbose
./scripts/orchestrator.sh --verbose install sua-solucao
```

### Checklist de Testes
- [ ] Script executa sem erros
- [ ] Logging está funcionando corretamente
- [ ] Tratamento de erros está adequado
- [ ] Documentação está atualizada
- [ ] Testado em ambiente limpo

## 📚 Estrutura de Solução

### Solução Completa
```bash
scripts/solutions/minha-solucao/
├── README.md           # Documentação da solução
├── install.sh          # Instalação
├── configure.sh        # Configuração
├── status.sh           # Status
├── uninstall.sh        # Desinstalação (opcional)
├── templates/          # Templates de configuração (opcional)
└── playbooks/          # Playbooks Ansible (opcional)
```

### README.md da Solução
```markdown
# Nome da Solução

## Descrição
Breve descrição da solução

## Requisitos
- Ferramenta 1
- Ferramenta 2

## Instalação
\`\`\`bash
./scripts/orchestrator.sh install minha-solucao
\`\`\`

## Configuração
\`\`\`bash
./scripts/orchestrator.sh configure minha-solucao
\`\`\`

## Uso
Instruções de uso

## Referências
- Link 1
- Link 2
```

## 🔄 Processo de Review

### O que Revisamos
1. **Funcionalidade**: O código faz o que deveria?
2. **Qualidade**: Segue os padrões do projeto?
3. **Documentação**: Está bem documentado?
4. **Testes**: Foi testado adequadamente?
5. **Segurança**: Há riscos de segurança?

### Tempo de Review
- Issues: 1-3 dias
- Pull Requests: 3-7 dias

## 🏆 Boas Práticas

### ✅ Faça
- Mantenha commits pequenos e focados
- Escreva mensagens de commit claras
- Adicione testes quando possível
- Atualize documentação
- Siga os padrões existentes
- Seja respeitoso nas discussões

### ❌ Evite
- Commits grandes demais
- Múltiplas features em um PR
- Alterar código não relacionado
- Remover funcionalidades sem discussão
- Ignorar feedback de review

## 📝 Mensagens de Commit

### Formato
```
Tipo: descrição curta (max 50 chars)

Descrição mais detalhada se necessário.
Pode usar múltiplas linhas.

Fixes #123
```

### Tipos
- `Adiciona:` - Nova funcionalidade
- `Corrige:` - Bug fix
- `Melhora:` - Melhoria de código existente
- `Documenta:` - Apenas documentação
- `Refatora:` - Refatoração de código
- `Testa:` - Adiciona ou corrige testes
- `Estilo:` - Formatação, sem mudança de código

### Exemplos
```bash
Adiciona: wrapper para kubectl

Implementa funções básicas de kubectl para
gerenciamento de pods e deployments.

Fixes #45
```

```bash
Corrige: erro no parse de argumentos

O parser não estava tratando corretamente
argumentos com espaços.

Fixes #67
```

## 🌟 Ideias de Contribuição

### Iniciante
- Corrigir typos na documentação
- Adicionar exemplos ao README
- Melhorar mensagens de log
- Adicionar validações de parâmetros

### Intermediário
- Criar nova solução simples
- Melhorar wrapper existente
- Adicionar testes
- Otimizar scripts

### Avançado
- Desenvolver solução complexa
- Implementar nova biblioteca
- Integração com novas ferramentas
- Sistema de plugins

## 📞 Comunicação

### Onde Buscar Ajuda
- 📫 [GitHub Issues](https://github.com/devopsvanilla/sre-superpanel/issues)
- 💬 [GitHub Discussions](https://github.com/devopsvanilla/sre-superpanel/discussions)
- 📖 [Wiki](https://github.com/devopsvanilla/sre-superpanel/wiki)

### Código de Conduta
- Seja respeitoso e inclusivo
- Aceite críticas construtivas
- Foque no que é melhor para a comunidade
- Mostre empatia com outros membros

## 📄 Licença

Ao contribuir, você concorda que suas contribuições serão licenciadas sob a Licença MIT.

---

**Obrigado por contribuir! Juntos tornamos o SRE SuperPanel melhor para todos! 🚀**
