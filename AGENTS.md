# Guia para agentes — Galeria

## Projeto e mapa

Galeria é uma aplicação de demonstração de deploy em Ruby e Sinatra clássico
(`Sinatra::Application`), com páginas HTML em ERB. Não é uma aplicação Rails.

| Caminho | Responsabilidade |
| --- | --- |
| `app.rb` | Rotas, sessões e coleção de imagens em memória |
| `config.ru` | Entrada Rack; execute os comandos a partir da raiz do projeto |
| `views/`, `public/style.css` | Templates, parciais e estilos |
| `config/otel-middleware.rb` | SDK, instrumentação e middleware OpenTelemetry |
| `spec/spec_helper.rb` | RSpec, Rack::Test e configuração da aplicação de teste |
| `spec/features/home_spec.rb` | Testes HTTP existentes da página inicial |
| `swagger.yaml`, `docs.html` | Contrato OpenAPI e página de documentação |
| `Dockerfile`, `Procfile`, `Makefile` | Empacotamento e execução |
| `.github/workflows/` | Release Drafter e publicação de imagens |

`POST /` adiciona uma imagem aleatória e redireciona para `/`; `GET /` lista
as imagens; `GET /photo/:id` mostra uma imagem. `/docs` e `/swagger.yaml`
servem a documentação. A coleção e o contador vivem no processo: não há banco,
persistência entre reinícios ou isolamento por sessão. Não pressuponha que o
404 declarado no OpenAPI já seja implementado para uma foto inexistente.

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

## Convenções de desenvolvimento

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

## Skills e perfis

Leia apenas a skill relevante, antes de aplicá-la. Instruções explícitas do
usuário e do ambiente prevalecem sobre estes fluxos. Não reabra decisões já
aprovadas. Use perguntas para decisões pendentes, não para fatos consultáveis.

| Situação | Skill local |
| --- | --- |
| Esclarecer uma ideia ou decisão | [grill-me](.agents/skills/grill-me/SKILL.md) |
| Converter decisões em uma especificação | [to-spec](.agents/skills/to-spec/SKILL.md) |
| Executar uma especificação em fatias verificáveis | [implement-spec](.agents/skills/implement-spec/SKILL.md) |
| Implementar ou corrigir comportamento com testes | [tdd](.agents/skills/tdd/SKILL.md) |
| Trabalhar em rotas, ERB e middleware | [ruby-sinatra](.agents/skills/ruby-sinatra/SKILL.md) |
| Revisar mudanças contra requisitos e convenções | [code-review](.agents/skills/code-review/SKILL.md) |

Os [perfis](.agents/README.md#perfis-de-agentes) são instruções Markdown para
desenvolvimento, testes e revisão. Leia o perfil solicitado na ferramenta em
uso; não presuma registro automático ou suporte a subagentes. Delegue somente
quando autorizado, usando áreas de escrita separadas.

## Entrega

Confira o diff, execute as verificações proporcionais à mudança e informe o que
foi executado, os resultados e as limitações. Mudanças apenas documentais pedem
checagem de links, metadados e whitespace; não exigem testes artificiais.
Para código, execute primeiro o spec relevante e depois a suíte RSpec.
Ao abrir PR, descreva problema, resultado e validação. A branch padrão deste
repositório é `master`; confirme o destino antes de abrir o PR.
