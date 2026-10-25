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
| Configurar as skills oficiais no projeto | [setup-matt-pocock-skills](skills/setup-matt-pocock-skills/SKILL.md) |
| Esclarecer uma ideia ou decisão | [grill-me](skills/grill-me/SKILL.md) |
| Converter decisões em uma especificação | [to-spec](skills/to-spec/SKILL.md) |
| Executar uma especificação em fatias verificáveis | [implement-spec](skills/implement-spec/SKILL.md) |
| Implementar ou corrigir comportamento com testes | [tdd](skills/tdd/SKILL.md) |
| Preparar a descrição de um PR | [pr](skills/pr/SKILL.md) |
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

Antes do primeiro uso das skills de engenharia, execute
`/setup-matt-pocock-skills` no seu agente. A skill oficial configura o tracker e
os documentos de domínio em `docs/agents/`, conforme o
[guia de setup](https://www.aihero.dev/skills-setup-matt-pocock-skills).
Instalar a skill não executa essa configuração; neste PR ela está disponível
para uso, sem escolher um tracker ou criar issues por conta própria.

As skills oficiais permanecem em inglês, com seus arquivos auxiliares e
metadados originais. Regras de RSpec, Sinatra e formato da revisão automática
ficam em [development.md](development.md), [review-tools.md](review-tools.md)
e nos perfis, sem editar os arquivos do Matt Pocock. `spec/` é reservado a RSpec.

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

## Instalação e atualização

Use o instalador oficial na raiz do projeto (Node.js/npm necessários apenas
para instalar ou atualizar):

```sh
npx skills@latest add mattpocock/skills --skill=tdd --agent codex --yes
npx skills@latest add mattpocock/skills --skill=pr --agent codex --yes
npx skills@latest add mattpocock/skills \
  --skill grill-me grilling to-spec to-tickets implement-spec code-review \
  codebase-design domain-modeling setup-matt-pocock-skills --agent codex --yes
```

A seleção `codex` usa `.agents/skills/`, também descoberta pelo OpenCode.
As skills de apoio (`grilling`, `codebase-design`, `domain-modeling` e
`to-tickets`) atendem às referências dos fluxos principais. Os arquivos são
versionados para poderem ser usados sem acesso à rede.

Não modifique as skills oficiais para aplicar regras locais. Atualize-as pelo
instalador, revise o diff e registre a origem em [SOURCES.md](SOURCES.md).
A licença está em [licenses/mattpocock-skills-MIT.txt](licenses/mattpocock-skills-MIT.txt).
`ruby-sinatra` e os três perfis são conteúdo local do projeto.

Nesta execução, `npx skills@latest` falhou com HTTP 503 no registro npm. Para
substituir as adaptações sem alterar o conteúdo oficial, os arquivos foram
obtidos diretamente do GitHub na revisão registrada, com hashes Git conferidos.
Não foi gerado um lockfile de instalador nem declarada uma instalação npx bem-sucedida.
