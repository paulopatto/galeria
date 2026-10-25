# Ferramentas para agentes

Comece pelo [AGENTS.md](../AGENTS.md). As skills ficam em
`skills/<nome>/SKILL.md`, com metadados YAML `name` e `description`.
São arquivos versionados e editáveis; não exigem npm, plugin ou instalação
global para serem lidos.

## Skills

Leia apenas a skill relevante, antes de aplicá-la. Instruções explícitas do
usuário e do ambiente prevalecem sobre estes fluxos. Não reabra decisões já
aprovadas. Use perguntas para decisões pendentes, não para fatos consultáveis.

| Situação | Skill local |
| --- | --- |
| Esclarecer uma ideia ou decisão | [grill-me](skills/grill-me/SKILL.md) |
| Converter decisões em uma especificação | [to-spec](skills/to-spec/SKILL.md) |
| Executar uma especificação em fatias verificáveis | [implement-spec](skills/implement-spec/SKILL.md) |
| Implementar ou corrigir comportamento com testes | [tdd](skills/tdd/SKILL.md) |
| Trabalhar em rotas, ERB e middleware | [ruby-sinatra](skills/ruby-sinatra/SKILL.md) |
| Revisar mudanças contra requisitos e convenções | [code-review](skills/code-review/SKILL.md) |

## Uso

Em ferramentas que descobrem `.agents/skills/`, selecione a skill pelo nome
(no Codex, por exemplo, `$tdd`). A sintaxe de comando depende da ferramenta.
Se não houver descoberta automática, peça explicitamente:

> Leia `.agents/skills/implement-spec/SKILL.md` e implemente a especificação abaixo.

Fluxo sugerido: `grill-me` quando houver decisões abertas → `to-spec` para
documentar → `implement-spec` usando `tdd` e `ruby-sinatra` → `code-review`.
Para um bug pequeno, use diretamente `tdd`; não transforme toda tarefa em
uma entrevista. As skills de entrevista e especificação são de uso explícito.

Specs podem ser fornecidas na conversa ou salvas em `docs/specs/<tema>.md`
quando fizer sentido versioná-las. `spec/` é reservado aos testes RSpec.
Não é necessário configurar um issue tracker para usar estes fluxos. Crie
issues ou publique documentos externos somente quando solicitado.

## Perfis de agentes

| Perfil | Quando ler | Resultado esperado |
| --- | --- | --- |
| [ruby-sinatra-developer](agents/ruby-sinatra-developer.md) | Implementação Ruby, rotas e views | Mudança pequena com validação |
| [rspec-test-engineer](agents/rspec-test-engineer.md) | Regressão, isolamento e testes HTTP | Reprodução e testes de comportamento |
| [code-reviewer](agents/code-reviewer.md) | Revisão de diff ou PR | Achados acionáveis com evidência |

Esses perfis são prompts portáveis. O perfil `code-reviewer` também é registrado
como agente primário nativo do OpenCode em [opencode.json](../opencode.json),
com shell/web habilitados para verificações e edição/delegação desabilitadas.
Use `opencode run --agent code-reviewer "Revise o diff desta branch"` ou o workflow
automatizado. Consulte o [guia de ferramentas](review-tools.md) para scanners e
Playwright, e a [documentação do workflow](../docs/automated-code-review.md).
Para usá-los, peça à ferramenta que leia o arquivo; configure qualquer agente
nativo conforme o formato suportado por ela. Um agente único também pode
adotar cada perfil sequencialmente. Este diretório não habilita execução
paralela, permissões ou acesso a serviços.

## Origem e manutenção

Cinco skills são adaptações locais do trabalho de Matt Pocock, apresentado em
[AI Hero](https://www.aihero.dev/skills). Veja [SOURCES.md](SOURCES.md) para
revisão, arquivos de origem e alterações; a licença original está em
[licenses/mattpocock-skills-MIT.txt](licenses/mattpocock-skills-MIT.txt).
`ruby-sinatra` e os três perfis foram escritos para este projeto.

Para atualizar, compare os arquivos de origem na revisão registrada com a
nova revisão, revise as diferenças e aplique apenas as mudanças pertinentes.
Preserve as adaptações Ruby/RSpec, atualize a referência e confira a licença.
Não sobrescreva este conjunto com um instalador ou atualização automática.

Ao adicionar uma skill, use uma pasta cujo nome corresponda ao campo `name`,
inclua uma descrição que explique quando usá-la e atualize o índice de skills neste arquivo. Confira metadados YAML, links relativos e `git diff --check`.
