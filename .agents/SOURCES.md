# Fontes das skills

Fonte: [mattpocock/skills](https://github.com/mattpocock/skills), divulgado em
[aihero.dev/skills](https://www.aihero.dev/skills).

Revisão consultada em 25/10/2026:
[`5beb35b040e3de97e54fa9e386d7e42d15c295c2`](https://github.com/mattpocock/skills/tree/5beb35b040e3de97e54fa9e386d7e42d15c295c2).
Licença: MIT, Copyright (c) 2026 Matt Pocock. O texto integral original está
em [licenses/mattpocock-skills-MIT.txt](licenses/mattpocock-skills-MIT.txt).

As skills abaixo são **adaptações**, não cópias integrais nem uma instalação
oficial do pacote. Os caminhos da coluna origem são relativos à revisão acima.

| Skill local | Arquivos de origem |
| --- | --- |
| `grill-me` | `skills/productivity/grill-me/SKILL.md`, `skills/productivity/grilling/SKILL.md` |
| `to-spec` | `skills/engineering/to-spec/SKILL.md` |
| `implement-spec` | `skills/engineering/implement-spec/SKILL.md` |
| `tdd` | `skills/engineering/tdd/SKILL.md`, `tests.md`, `mocking.md` na mesma pasta |
| `code-review` | `skills/engineering/code-review/SKILL.md` |

## Adaptações deliberadas

- Tradução e exemplos próprios para Ruby, Sinatra clássico, RSpec e Rack::Test.
- `grill-me` incorpora o fluxo de `grilling` para não depender de outra skill.
- As referências essenciais de TDD foram incorporadas ao próprio documento;
  não há dependência de exemplos TypeScript, Jest ou skills não incluídas.
- A fronteira HTTP existente é o ponto de teste padrão. Uma tarefa já acordada
  não exige uma nova aprovação de cada teste; decisões que alteram escopo continuam
  sendo explicitadas. Refatorações pequenas ocorrem com testes verdes.
- Especificações funcionam na conversa ou em arquivos locais, sem setup
  obrigatório de tracker, labels ou publicação automática de issues.
- `implement-spec` mantém dependências e integração incremental; paralelismo
  é opcional e condicionado à autorização e ao suporte da ferramenta.
- `code-review` mantém revisão de requisitos e de padrões separadas, podendo
  executá-las sequencialmente; não exige subagentes.
- Foram removidas dependências de ferramentas específicas, como `Skill tool`,
  e ações automáticas de merge, fechamento de tickets ou publicação externa.

`ruby-sinatra` e `agents/*.md` são conteúdo específico da Galeria.
