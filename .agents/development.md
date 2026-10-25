# Desenvolvimento e validação

## Preparação e comandos

A versão declarada em `.ruby-version` e no Dockerfile é Ruby **2.6.2**.
O lockfile registra Bundler **1.17.2**, Sinatra **2.2.4** e RSpec **3.13.1**.
Consulte os arquivos atuais antes de alterar compatibilidade. Não atualize
Ruby, gems ou o lockfile incidentalmente em tarefas de documentação.

```sh
bundle install
# Opcional: copie .env-sample para .env para configuração local.
RACK_ENV=development OTEL_TRACES_EXPORTER=console bundle exec rackup config.ru -p 9000

# Defina RACK_ENV antes de carregar app.rb; o helper atual o define após o require.
RACK_ENV=test OTEL_TRACES_EXPORTER=none bundle exec rspec
RACK_ENV=test OTEL_TRACES_EXPORTER=none bundle exec rspec spec/features/home_spec.rb
RACK_ENV=test OTEL_TRACES_EXPORTER=none bundle exec rspec --seed 1234

ruby -c app.rb
ruby -c config/otel-middleware.rb
git diff --check
```

A instalação de `thrift` pode exigir compilador e flags específicas do sistema;
consulte a seção correspondente no README e `.bundle/config`. Preserve o
lockfile ao resolver problemas locais. Se o runtime ou dependências não
estiverem disponíveis, informe o comando bloqueado e a causa. Não afirme que
testes passaram sem executá-los. Não há RuboCop, tarefa Rake de testes ou
workflow de CI que execute RSpec atualmente.

## Convenções Ruby e Sinatra

- Preserve compatibilidade com Ruby 2.6 e o estilo Ruby existente: indentação
  de dois espaços, nomes `snake_case` e alterações pequenas e focadas.
- Mantenha rotas simples. Extraia lógica para objetos Ruby quando houver uma
  responsabilidade concreta; não introduza Rails, ORM ou camadas especulativas.
- Teste comportamento HTTP com RSpec e Rack::Test: status, redirecionamento,
  conteúdo e fluxo observável. Não teste variáveis locais ou métodos privados.
- Os testes executam em ordem aleatória. Não dependa de IDs fixos, galeria vazia
  ou execução anterior de outro exemplo; crie os próprios dados pela interface
  HTTP e observe o estado compartilhado antes de escolher uma estratégia de isolamento.
- Não faça chamadas reais ao Unsplash ou a coletores de tracing nos testes.
  Rack::Test não baixa imagens referenciadas no HTML; use `OTEL_TRACES_EXPORTER=none`.
- Ao alterar rotas, confira templates e `swagger.yaml`. Trate entrada inválida,
  escape de conteúdo dinâmico e sessões conforme o comportamento solicitado.
- No middleware, preserve o contrato Rack `[status, headers, body]`, a propagação
  de contexto e a semântica dos spans. Não registre segredos ou dados sensíveis.
- Não versione `.env`, credenciais, gems instaladas, logs ou artefatos de build.
  Publicar imagens ou executar deploy exige que isso faça parte do pedido.

## Entrega

Para mudanças de comportamento, siga TDD com RSpec e Rack::Test: confirme o
teste falhando, implemente o mínimo e refatore com os testes verdes. Consulte
a [skill tdd](skills/tdd/SKILL.md) quando necessário. Execute primeiro o spec
afetado e depois a suíte completa.

Para documentação, confira links, metadados e `git diff --check`; não crie
testes artificiais. Informe comandos executados, resultados e limitações.
Ao abrir PR, descreva o problema, o resultado e a validação.
