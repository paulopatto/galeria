# Code review automatizado com OpenCode

O workflow [OpenCode PR review](../.github/workflows/opencode-review.yml) usa
`opencode/big-pickle` para revisar pull requests e publicar a resposta em um
comentário no próprio PR. A action seleciona `agent: code-reviewer`, registrado
como agente primário em [opencode.json](../opencode.json), e carrega o perfil
[code-reviewer](../.agents/agents/code-reviewer.md). O workflow contém apenas
um prompt curto de execução; as regras ficam no agente e no
[guia de ferramentas](../.agents/review-tools.md).

O comentário é em português brasileiro: uma linha de resumo com o commit e
somente achados acionáveis, com severidade, arquivo/linha, impacto e correção.
Além do comentário, o workflow publica um review formal conforme a política abaixo.
Comandos, versões, limitações e evidências ficam no toggle **Detalhes da análise**.
Achados relevantes e limitações que comprometam a conclusão permanecem visíveis.
Se não houver achados, o agente informa isso sem gerar seções vazias.

## Configuração

1. Gere uma API key no [OpenCode Console](https://opencode.ai/console) com acesso
   ao modelo Big Pickle.
2. No repositório, abra **Settings → Secrets and variables → Actions → New
   repository secret** e salve a chave como `OPENCODE_API_KEY`.
3. Habilite GitHub Actions e permita as actions `actions/checkout` e
   `anomalyco/opencode/github`, `actions/github-script` e `actions/upload-artifact`, caso exista uma política
   de restrição de actions.
   A política da organização também precisa permitir `pull-requests: write` e
   `issues: write`.
4. Em **Settings → Actions → General → Workflow permissions**, habilite
   **Allow GitHub Actions to create and approve pull requests**, se permitido
   pela política da organização. O token precisa de `pull-requests: write`.
5. Abra ou atualize um PR de uma branch deste repositório e confira o job
   **review**, o comentário e o review formal no PR. Se o GitHub negar a criação
   do review (por política ou por autorrevisão), o passo falha explicitamente;
   o workflow não considera a aprovação concluída.

O workflow usa `use_github_token: true` e o `GITHUB_TOKEN` temporário fornecido
pelo GitHub. Não é necessário instalar o GitHub App do OpenCode, criar um PAT ou
configurar OIDC. As permissões são `contents: read`, `pull-requests: write` e
`issues: write`. Comentários e reações usam endpoints de issues, mas o recurso
revisado é um pull request e precisa de acesso de escrita em pull requests.
`contents: read` impede a publicação de commits com esse token.
O checkout não persiste credenciais e o compartilhamento público de sessões
OpenCode fica desabilitado (`share: false`).

## Quando e como a revisão acontece

- Executa em `opened`, `synchronize`, `reopened` e `ready_for_review`, inclusive
  em drafts. Novos commits disparam uma nova análise do diff completo.
- Uma execução nova cancela a anterior do mesmo PR para reduzir análises
  desatualizadas. PRs diferentes são revisados independentemente.
- O job tem limite de 20 minutos. Falhas de autenticação, indisponibilidade ou
  limites do provedor aparecem no Actions; não há fallback para outro modelo.
- A action publica um comentário por execução. Comentários de execuções
  anteriores podem permanecer: confira o commit e a execução correspondentes.
- O review apresenta resumo, achados com severidade, arquivo/linha, impacto e
  sugestão de correção, além das ferramentas executadas e limitações.
- O agente grava `decision.json` no diretório de evidências com o SHA analisado,
  conclusão da análise e achados estruturados. Um passo separado valida o schema
  e calcula o evento; o agente não escolhe diretamente a aprovação.
- Crítica ou alta: **Solicitar alterações** (`REQUEST_CHANGES`).
- Somente médias: **Comentar** (`COMMENT`), sem aprovação nem solicitação de alterações.
- Análise completa sem achados ou somente baixas: **Aprovar** (`APPROVE`).
- Análise incompleta sem achado crítico/alto: somente comentário. JSON ausente,
  inválido ou de outro SHA falha o passo, sem publicar aprovação.
- Antes de publicar, o workflow confere o SHA atual do PR. Se a branch mudou ou
  o PR foi fechado, a decisão antiga é descartada. Em drafts, uma aprovação é
  convertida em comentário até o evento `ready_for_review`.
- A aprovação não faz merge nem dispensa outras revisões ou checks obrigatórios.
  O efeito de uma solicitação de alterações depende das regras do repositório.

PRs de forks e do Dependabot executam apenas o job **unavailable**, que explica
a ausência de review no resumo do Actions. Nesses eventos, o GitHub normalmente
retém secrets e fornece token somente de leitura. Faça a revisão humana; para
usar a automação, um mantenedor pode inspecionar a contribuição e trazê-la para
uma branch do próprio repositório. Não use `pull_request_target` com checkout
do código do contribuidor para contornar essa restrição.

## Ferramentas e evidências

O agente tem acesso a shell e web para verificações; as ferramentas de edição e
delegação estão desabilitadas. As permissões de shell não constituem sandbox:
o perfil também proíbe alterar código ou executar scripts do PR com credenciais.

Consulte o [guia de ferramentas](../.agents/review-tools.md) para seleção,
comandos, isolamento e limitações de Bundler-audit, Dawnscanner, Brakeman e
RuboCop/Security. Brakeman só se aplica a Rails; os cops Security fazem parte
do RuboCop. Ferramentas não são instaladas automaticamente e nenhum scanner é
obrigatório em todos os PRs. O runtime da aplicação continua Ruby 2.6.2/Sinatra 2.x.

Playwright é opcional para uma URL de preview autorizada, quando houver mudança
visual ou necessidade de evidência. Não se inicia a aplicação do PR no job com
secrets. Se não houver preview ou navegador, a limitação aparece nos detalhes.
O workflow não instala Playwright, browsers ou servidores MCP.

Screenshots e relatórios pertinentes devem ser gravados em
`$RUNNER_TEMP/code-review-evidence`. A action publica essa pasta como artefato
`code-review-evidence-<PR>-<tentativa>`, com retenção de sete dias. A saída
estruturada `decision.json` também fica nesse artefato. Sem arquivos, o upload
é ignorado. Nunca inclua tokens, sessões, dados pessoais ou logs completos.

## Diagnóstico e manutenção

- **Secret ausente:** o passo **Check OpenCode credentials** falha com instruções;
  cadastre `OPENCODE_API_KEY` e use **Re-run jobs**.
- **401/403 do provedor:** confira a validade da chave e o acesso a Big Pickle
  no Console. **403 do GitHub ao reagir/comentar:** confira em **Set up job →
  GITHUB_TOKEN Permissions** se `PullRequests: write` e `Issues: write` estão
  presentes. `permission: admin` no log é a permissão do usuário que disparou a
  execução, não a do token da action. Após corrigir o workflow, use a execução
  disparada pelo novo commit: reexecutar um run antigo reutiliza sua revisão do
  workflow e pode preservar a configuração incorreta. Se as permissões efetivas
  continuarem somente de leitura, confira a política de Actions da organização.
- **Rate limit, timeout ou indisponibilidade:** consulte os logs e tente
  **Re-run jobs**. Não considere o PR revisado se não houver resposta completa.
- **PR já aberto antes da inclusão do workflow:** envie um novo commit ou
  reabra o PR para disparar a revisão.
- As actions estão fixadas em commits. Ao atualizá-las, valide seus inputs.
  A action oficial instala a versão atual do CLI OpenCode; fixar a action não
  fixa o CLI nem a disponibilidade do modelo no provedor.

O código e o contexto enviados ao modelo são processados pelo OpenCode.
Segundo a documentação, dados coletados durante o período gratuito do Big
Pickle podem ser usados para melhorar o modelo. `share: false` desabilita links
públicos de sessão, mas não altera a política do provedor. Não envie secrets
ou dados pessoais no código ou nos comentários.

Referências: [integração GitHub e exemplo de PR](https://opencode.ai/docs/github/#pull-request-example)
e [modelos e privacidade](https://opencode.ai/v2/docs/console/models/).

