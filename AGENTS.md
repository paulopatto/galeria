# Guia para agentes

## Princípios

- **KISS:** escolha a solução mais simples que resolva o problema atual.
- **YAGNI:** implemente apenas o necessário; evite abstrações, configurações
  e camadas para necessidades futuras.
- **TDD:** primeiro escreva o teste com RSpec e veja-o falhar; depois implemente
  o mínimo para passar e refatore com os testes verdes. Use a
  [skill tdd](.agents/skills/tdd/SKILL.md) quando necessário.
- **Comunicação:** seja breve e direto. Escreva código e comentários em inglês.
- **Commits:** siga [Conventional Commits](.agents/workflow.md#commits).
- **Multiagentes:** use uma branch e um worktree por tarefa de implementação;
  siga o [fluxo de worktrees](.agents/workflow.md#tarefas-com-multiagentes).

## Referências

Leia os detalhes conforme a tarefa:

- [Projeto e arquitetura](.agents/project.md).
- [Comandos, convenções Ruby/Sinatra e validação](.agents/development.md).
- [Git, commits e trabalho com multiagentes](.agents/workflow.md).
- [Índice de skills e perfis de agentes](.agents/README.md).
