# Origem das skills

Fonte oficial: [mattpocock/skills](https://github.com/mattpocock/skills), divulgado
em [AI Hero](https://www.aihero.dev/skills). Guia:
[setup-matt-pocock-skills](https://www.aihero.dev/skills-setup-matt-pocock-skills).

Revisão dos arquivos:
[`5beb35b040e3de97e54fa9e386d7e42d15c295c2`](https://github.com/mattpocock/skills/tree/5beb35b040e3de97e54fa9e386d7e42d15c295c2).
Os arquivos são originais, sem tradução ou adaptação, incluindo os auxiliares e
`agents/openai.yaml`. Seus hashes de blob Git foram comparados com a origem.

| Pasta de origem | Skills em `.agents/skills/` |
| --- | --- |
| `skills/engineering/` | `tdd`, `pr`, `to-spec`, `to-tickets`, `implement-spec`, `code-review`, `codebase-design`, `domain-modeling`, `setup-matt-pocock-skills` |
| `skills/productivity/` | `grill-me`, `grilling` |

Licença: MIT, Copyright (c) 2026 Matt Pocock. Texto integral em
[licenses/mattpocock-skills-MIT.txt](licenses/mattpocock-skills-MIT.txt).

## Método de obtenção

A instalação via `npx skills@latest add mattpocock/skills` foi tentada, mas o
registro npm respondeu HTTP 503. Os 34 arquivos oficiais foram então obtidos
pelo conector GitHub na revisão acima e gravados sem alterações. Não há
`skills-lock.json` gerado pelo instalador nesta execução.

Os [comandos de instalação](README.md#instalação-e-atualização) ficam disponíveis
para executar o instalador quando o acesso ao npm funcionar. Depois de instalar,
execute `/setup-matt-pocock-skills` para configurar tracker e documentos de domínio.

`ruby-sinatra`, `agents/*.md` e os guias do projeto são conteúdo local, separado
das skills oficiais. O perfil automatizado `code-reviewer` define o comentário
curto do CI sem alterar ou executar o fluxo interativo da skill oficial.

## Ponytail e Caveman

As skills abaixo foram instaladas sem alterações via `npx skills@latest add`,
com `--agent codex --yes --skill '*'`. As origens, caminhos e hashes de cada
skill ficam versionados em [`skills-lock.json`](../skills-lock.json).

| Fonte | Skills instaladas | Licença declarada |
| --- | --- | --- |
| [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) | `ponytail`, `ponytail-audit`, `ponytail-debt`, `ponytail-gain`, `ponytail-help`, `ponytail-review` | MIT |
| [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) | `cavecrew`, `caveman`, `caveman-*`, `investigate-first`, `lean-build`, `megacave`, `migration`, `safe-refactor`, `surgical-patch`, `ultracave`, `verify-and-stop` | Apache-2.0 |
