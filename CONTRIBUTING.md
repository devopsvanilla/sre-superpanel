# 🤝 Guia de Contribuição

Obrigado por considerar contribuir com o SRE SuperPanel! Este documento fornece diretrizes para contribuir com o projeto.

## 📋 Índice

- [Código de Conduta](#código-de-conduta)
- [Como Posso Contribuir?](#como-posso-contribuir)
- [Diretrizes de Contribuição](#diretrizes-de-contribuição)
- [Processo de Pull Request](#processo-de-pull-request)
- [Padrões de Qualidade](#padrões-de-qualidade)

## 📜 Código de Conduta

Este projeto adere a um Código de Conduta. Ao participar, espera-se que você mantenha um ambiente respeitoso e acolhedor para todos.

## 🎯 Como Posso Contribuir?

### Reportar Bugs

- Use a aba "Issues" do GitHub
- Descreva o problema claramente
- Inclua passos para reproduzir
- Adicione capturas de tela se aplicável

### Sugerir Melhorias

- Abra uma issue com a tag "enhancement"
- Descreva o caso de uso
- Explique os benefícios esperados

### Contribuir com Código

#### Dashboards

1. Navegue até `dashboards/`
2. Adicione seu dashboard em formato JSON
3. Inclua um README explicando:
   - Finalidade do dashboard
   - Métricas exibidas
   - Pré-requisitos
   - Instruções de importação

**Exemplo de estrutura:**
```
dashboards/grafana/kubernetes/
├── k8s-cluster-overview.json
└── README.md
```

#### Indicadores

1. Navegue até `indicators/`
2. Adicione seus SLIs/SLOs
3. Documente:
   - Métrica monitorada
   - Threshold recomendado
   - Justificativa

#### Receitas

1. Navegue até `recipes/`
2. Crie um novo arquivo Markdown
3. Siga o template:

```markdown
# Título da Receita

## Problema
[Descreva o problema que esta receita resolve]

## Solução
[Passo a passo da solução]

## Pré-requisitos
[Ferramentas/permissões necessárias]

## Passos
1. [Primeiro passo]
2. [Segundo passo]
...

## Verificação
[Como validar que funcionou]

## Referências
[Links úteis]
```

#### Base de Conhecimento

1. Navegue até `knowledge-base/`
2. Adicione artigos em Markdown
3. Mantenha linguagem clara e objetiva
4. Inclua exemplos práticos

## 📝 Diretrizes de Contribuição

### Estilo de Código

- Use nomes descritivos para arquivos
- Mantenha documentação em português
- Inclua comentários quando necessário
- Siga as convenções do tipo de arquivo (JSON, YAML, etc.)

### Commits

Use mensagens de commit claras e descritivas:

- `feat: adiciona dashboard de PostgreSQL`
- `docs: atualiza guia de troubleshooting`
- `fix: corrige threshold de memória no SLO`
- `refactor: reorganiza estrutura de receitas`

### Branches

- `main`: branch principal, sempre estável
- `feature/nome-da-feature`: para novas funcionalidades
- `fix/nome-do-bug`: para correções
- `docs/nome-da-doc`: para documentação

## 🔄 Processo de Pull Request

1. **Fork** o repositório
2. **Clone** seu fork localmente
3. **Crie** uma branch a partir da `main`
4. **Faça** suas alterações
5. **Teste** suas contribuições
6. **Commit** com mensagens claras
7. **Push** para seu fork
8. **Abra** um Pull Request

### Checklist do PR

- [ ] Código/documentação segue os padrões do projeto
- [ ] Adicionei/atualizei documentação necessária
- [ ] Testei as alterações
- [ ] Atualizei o README se necessário
- [ ] O PR tem uma descrição clara

### Revisão

- Todos os PRs serão revisados por mantenedores
- Feedback será fornecido de forma construtiva
- Podem ser solicitadas alterações
- Após aprovação, o PR será mesclado

## ✅ Padrões de Qualidade

### Dashboards

- Testados na versão atual do Grafana
- Incluem datasources configuráveis
- Têm documentação de uso

### Indicadores

- Baseados em práticas reconhecidas (Google SRE, etc.)
- Incluem justificativa técnica
- Têm thresholds realistas

### Receitas

- Passos claros e reproduzíveis
- Testadas em ambiente real
- Incluem tratamento de erros

### Documentação

- Sem erros de ortografia
- Formatação Markdown correta
- Links funcionais
- Exemplos práticos

## 🆘 Precisa de Ajuda?

- Abra uma issue com a tag "question"
- Entre em contato com os mantenedores
- Consulte a documentação existente

---

**Obrigado por contribuir com o SRE SuperPanel! 🚀**
