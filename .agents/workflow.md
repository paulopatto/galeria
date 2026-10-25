# Git e colaboração

## Commits

Siga [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/):
`tipo(escopo opcional): descrição`. Escreva mensagens em inglês, curtas e
específicas, agrupando mudanças com um único propósito.

Exemplos: `feat(gallery): handle missing photos`,
`fix(tracing): preserve Rack response body`,
`docs(agents): simplify agent guidance` e `test(gallery): cover redirects`.
Use `!` ou o rodapé `BREAKING CHANGE:` para mudanças incompatíveis.

Confira `git status` e o diff antes de fazer commit. Preserve alterações do
usuário; não inclua arquivos alheios à tarefa, credenciais ou artefatos locais.
A branch padrão é `master`; confirme a base do PR no repositório remoto.

## Tarefas com multiagentes

Delegue somente quando autorizado e quando a ferramenta oferecer suporte.
Para cada tarefa de implementação delegada, use uma branch e um worktree
próprios, criados a partir da branch de integração. Agentes de leitura podem
compartilhar o checkout desde que não editem arquivos nem alterem seu estado Git.

1. Defina escopo, critérios de aceitação, dependências e responsável por integrar.
2. A partir da branch de integração acordada, crie um worktree por tarefa:

   ```sh
   git worktree add -b feat/photo-validation ../galeria-photo-validation HEAD
   ```

3. Oriente o implementador a trabalhar apenas no worktree atribuído e a seguir
   TDD. Se a tarefa depender de outra, aguarde a integração da dependência.
4. Faça commits com Conventional Commits. Antes de entregar, integre as mudanças
   recentes da branch de integração e resolva conflitos no próprio worktree.
5. O responsável integra cada branch e valida o conjunto antes de liberar
   tarefas dependentes. Não faça edições concorrentes no mesmo checkout.
6. Depois de integrar e confirmar que o worktree está limpo, remova apenas o
   worktree criado para a tarefa com `git worktree remove <caminho>`.
   Não use remoção forçada nem descarte trabalho pendente.

Para execução de uma especificação, consulte
[implement-spec](skills/implement-spec/SKILL.md). Não faça merge de PR, deploy
ou publicação de imagens sem que isso faça parte do pedido.
