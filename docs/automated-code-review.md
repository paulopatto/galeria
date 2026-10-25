# Code review automatizado com OpenCode

O workflow [OpenCode PR review](../.github/workflows/opencode-review.yml) usa
`opencode/big-pickle` para revisar pull requests e publicar a resposta em um
comentário no próprio PR. O prompt fica no campo `prompt` do workflow e a resposta
é em português brasileiro, com foco em qualidade Ruby, Sinatra e segurança.

## Configuração

1. Gere uma API key no [OpenCode Console](https://opencode.ai/console) com acesso
   ao modelo Big Pickle.
2. No repositório, abra **Settings → Secrets and variables → Actions → New
   repository secret** e salve a chave como `OPENCODE_API_KEY`.
3. Habilite GitHub Actions e permita as actions `actions/checkout` e
   `anomalyco/opencode/github`, caso exista uma política de restrição de actions.
   A política da organização também precisa permitir `pull-requests: write` e
   `issues: write`.
4. Abra ou atualize um PR de uma branch deste repositório e confira o job
   **review** na aba **Actions** e o comentário no PR.

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
- O parecer é consultivo. Achados não bloqueiam automaticamente o merge nem
  equivalem a uma aprovação. Não configure esse workflow como check obrigatório
  sem considerar sua dependência do serviço externo e as exceções abaixo.

PRs de forks e do Dependabot executam apenas o job **unavailable**, que explica
a ausência de review no resumo do Actions. Nesses eventos, o GitHub normalmente
retém secrets e fornece token somente de leitura. Faça a revisão humana; para
usar a automação, um mantenedor pode inspecionar a contribuição e trazê-la para
uma branch do próprio repositório. Não use `pull_request_target` com checkout
do código do contribuidor para contornar essa restrição.

## Ruby antigo e scanners

A aplicação continua com Ruby 2.6.2 e Sinatra 2.x. Este workflow não instala o
bundle da aplicação e não modifica suas dependências. O prompt exige sugestões
compatíveis com a stack atual; a atualização de Ruby/Sinatra fica para outra tarefa.

Os scanners são auxiliares sob demanda, escolhidos pelo agente conforme o diff,
a disponibilidade e a compatibilidade do runtime. Não são etapas obrigatórias
nem há garantia de execução dos quatro scanners em cada PR:

| Ferramenta | Quando usar |
| --- | --- |
| Bundler-audit | Mudanças nas dependências; analisa `Gemfile.lock` contra advisories atualizados. |
| Dawnscanner | Análise estática complementar de Sinatra, quando compatível. |
| Brakeman | Somente se houver código Rails; não se aplica à aplicação Sinatra atual. |
| RuboCop-Security | Padrões Ruby inseguros, sem autocorreção, com configuração temporária própria e alvo Ruby 2.6. |

Se necessário, o agente pode instalar ferramentas fora do bundle, em diretório
temporário. O prompt proíbe executar a aplicação, scripts/testes do PR ou avaliar
o Gemfile, e limita cada scanner a 120 segundos. Isso evita depender da instalação
do Ruby legado para fazer o review. Erros de instalação, parsing, rede ou
incompatibilidade devem aparecer como limitações; não significam ausência de
vulnerabilidades nem devem gerar pedidos de upgrade fora do escopo do PR.

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
