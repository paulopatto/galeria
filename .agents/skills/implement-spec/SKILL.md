---
name: implement-spec
description: Implemente uma especificação acordada em fatias com dependências explícitas, testes de comportamento e revisão final.
disable-model-invocation: true
---

# Implementar uma especificação

Adaptação de Matt Pocock; origem e licença em [SOURCES.md](../../SOURCES.md).

## Preparar

Leia a especificação fornecida, `AGENTS.md` e o código afetado. Se não existir
uma especificação formal, use os critérios acordados na conversa. Esclareça
apenas lacunas que impeçam uma implementação correta.

Confira a branch e o estado do Git; preserve alterações do usuário. Registre
uma lista curta de fatias com critérios de conclusão e dependências. Trabalhe
em branch própria quando necessário. Não é obrigatório ter tickets externos.

## Executar

1. Escolha uma fatia cujas dependências estejam concluídas.
2. Consulte [ruby-sinatra](../ruby-sinatra/SKILL.md) para as convenções locais
   e [tdd](../tdd/SKILL.md) para mudanças de comportamento.
3. Implemente a fatia e execute a validação pertinente antes da seguinte.
4. Atualize o progresso com evidências: arquivos, comandos, resultados e
   decisões. Não declare concluído um critério sem verificá-lo.
5. Integre cada fatia preservando o estado funcional da branch.

O padrão é execução sequencial. Se o usuário autorizar subagentes e a ferramenta
oferecer suporte, distribua somente fatias independentes. Cada implementador
deve receber os critérios, os arquivos de referência e uma área de escrita
isolada, preferencialmente um worktree baseado na branch de integração.
Integre e valide os resultados antes de liberar trabalho dependente. Não
delegue a edição simultânea do mesmo arquivo.

## Concluir

Execute os specs afetados e a suíte completa para mudanças Ruby. Em documentação,
confira metadados, links e diff. Use [code-review](../code-review/SKILL.md),
corrija os problemas relevantes e confira todos os critérios de aceitação.

Entregue o resultado e as limitações de validação. Abra PR se solicitado, com
destino confirmado e descrição dos resultados. Não faça merge, publique imagens
ou feche tickets apenas por executar esta skill.
