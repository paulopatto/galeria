# Ferramentas de qualidade e segurança

Use ferramentas para sustentar os achados da revisão. Escolha conforme o diff;
não é necessário executar todos os scanners em todo PR. Registre versão,
comando, código de saída, resultado e limitações. Confirme cada alerta no código
e diferencie regressão introduzida pelo PR de dívida preexistente.

## Ambiente e limites

- Confira `ruby --version` e a versão do scanner. O runtime de análise pode ser
  diferente do Ruby 2.6.2 da aplicação; as sugestões devem respeitar o projeto.
- Use ferramentas instaladas e compatíveis. Se precisar instalar gems, use
  `GEM_HOME`/`GEM_PATH` em diretório temporário fora do projeto, sem alterar o
  bundle, o lockfile ou `.ruby-version`. Não execute `bundle install` nem avalie
  o Gemfile do PR. Não carregue plugins ou configurações executáveis do PR.
- Limite cada scanner a 120 segundos com `timeout 120`. Incompatibilidade,
  falha de rede, parsing, timeout ou base desatualizada são limitações, não
  aprovação de segurança nem vulnerabilidades confirmadas.
- No CI, não execute a aplicação, testes ou scripts do PR com os secrets e o
  token de revisão presentes. Não use autocorreção nem altere arquivos revisados.
- Relatórios e screenshots podem ser gravados em diretório temporário. No
  workflow, use `$RUNNER_TEMP/code-review-evidence`; nunca inclua tokens,
  cookies, dados pessoais ou dumps de ambiente nos artefatos.

## Scanners

| Ferramenta | Aplicação e comando de referência |
| --- | --- |
| Bundler-audit | Audite o lockfile contra Ruby Advisory DB: `timeout 120 bundle-audit check --update --config <config-temporaria>`. Use configuração própria com `ignore: []` para não aceitar supressões do PR. Execute na raiz do projeto, fora de `bundle exec`; a ferramenta lê `Gemfile.lock`. Informe se a atualização da base falhar. |
| Dawnscanner | Scanner com suporte a Sinatra, Rails e Padrino. Confira `dawn --help` e a versão; na versão 2, use `timeout 120 dawn scan .`. Confirme disponibilidade e atualização da knowledge base com `dawn kb status`. Informe incompatibilidades com a sintaxe ou dependências atuais. |
| Brakeman | SAST específico de Rails. A Galeria atual é Sinatra: marque como não aplicável. Somente em código Rails, use `timeout 120 brakeman --path <diretorio-rails> --no-pager`. Não force modo Rails na aplicação Sinatra. |
| RuboCop / Security | Os cops `Security` fazem parte do RuboCop; não é necessário presumir uma gem chamada `rubocop-security`. Execute `timeout 120 rubocop --config <config-temporaria> --only Security --format json --cache false <arquivos-ruby>`, sem autocorreção. |

Para RuboCop, crie uma configuração temporária própria fora do repositório,
sem `inherit_from`, `require` ou plugins do PR:

```yaml
AllCops:
  TargetRubyVersion: 2.6
  NewCops: disable
```

Selecione uma versão do RuboCop que reconheça Ruby 2.6. Se a versão instalada
não o suportar, registre a limitação; não altere o alvo para simular cobertura.
Use caminhos explícitos dos arquivos Ruby revisados, incluindo `config.ru`
quando pertinente. Análise de ERB e fluxos de segurança também exige revisão
manual; nenhum desses scanners comprova sozinho a ausência de vulnerabilidades.

## Playwright e evidências visuais

Use quando houver mudança de interface ou um achado que precise de reprodução
no navegador. Utilize Playwright instalado, CLI ou ferramenta de navegador/MCP
disponível no ambiente. A configuração OpenCode não instala browsers ou MCPs.

- Acesse somente uma URL de preview autorizada, com dados de teste e sem sessão
  de produção. Não inicie a aplicação do PR no job que possui credenciais.
- Se não houver preview ou navegador disponível, registre que a verificação
  visual não foi executada; screenshots não são obrigatórias para mudanças Ruby
  sem impacto visual.
- Use script/configuração próprios fora do PR, limite tempo de navegação e
  capture somente os passos necessários. Não carregue `playwright.config` ou
  scripts fornecidos pelo PR no ambiente de revisão.
- Guarde screenshots em `$RUNNER_TEMP/code-review-evidence` no CI. No relatório,
  associe cada imagem ao cenário, à URL e ao resultado observado, sem parâmetros
  sensíveis. A action publica a pasta como artefato da execução, se existir.

Permitir shell e acesso à web habilita essas verificações no agente; não é um
sandbox de execução. As restrições acima também se aplicam aos comandos de shell.
