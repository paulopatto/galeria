# Gallery web app

Exemplo de aplicação de uma aplicação web para exemplos de deploy.
Essa aplicação foi desenvolvia no curso de deploy com Heroku da Udacity;
Fiz algumas alterações na aplicação para dar um treinamento de deploy no Heroku
no ChefsClub.com.br e depois foi usado para provas de conceito de infra estrtura
com Elastic BeanStalk por exemplo.

------

## Desenvolvimento com agentes de IA

Consulte o [AGENTS.md](AGENTS.md) para arquitetura, comandos e convenções do
projeto. A pasta [.agents/](.agents/README.md) contém skills oficiais de planejamento,
implementação, TDD, PR e revisão de Matt Pocock, uma skill local Ruby/Sinatra
e perfis de desenvolvimento, testes e revisão. A origem e a licença das
skills estão documentadas em [.agents/SOURCES.md](.agents/SOURCES.md).

## Code review automatizado

Pull requests recebem uma revisão do OpenCode com o modelo Big Pickle, focada em
Ruby/Sinatra e segurança. Veja a [documentação de configuração, funcionamento e
limitações](docs/automated-code-review.md).

## Como executar esse projeto

### Desenvolvimento

- 1. Instalar dependencias: `bundle install`
- 2. Chamar a linha de comando para rodar o servidor rack: `PORT=9000 bundle exec rackup ./config.ru -p $PORT`
- 3. Acesse http://localhost:9000/

### Via docker V1.0.x

Construa com: `docker build --tag galeria:1.0`
Execute com: `docker run --publish 9000:9000 --name galeria-web galeria:1.0`


### Otel

#### Environments

Configure as seguintes variáveis de ambiente para o Otel:

| Variável de Ambiente          | Descrição                                                                                          |
|-------------------------------|----------------------------------------------------------------------------------------------------|
| `OTEL_TRACES_EXPORTER`        | Define o formato do exporter. Exemplos: `console`, `otlp`, `zipkin`, `jaeger`, etc.                |
| `OTEL_EXPORTER_OTLP_ENDPOINT` | Define o endpoint de exportação de métricas OTLP.                                                  |

#### Para testes simples com Jaeger local

Suba um jaeger simples com docker local

```bash
docker run -d --name jaeger \
  -e COLLECTOR_ZIPKIN_HOST_PORT=:9411 \
  -e COLLECTOR_OTLP_ENABLED=true \
  -p 6831:6831/udp \
  -p 6832:6832/udp \
  -p 5778:5778 \
  -p 16686:16686 \
  -p 4317:4317 \
  -p 4318:4318 \
  -p 14250:14250 \
  -p 14268:14268 \
  -p 14269:14269 \
  -p 9411:9411 \
  jaegertracing/all-in-one:latest
```

Acesser http://localhost:16686/

#### Instalando o thrift

A gem thrift inclui extensões nativas em C, e o compilador (provavelmente Clang ao menos no macOS) é rigoroso com certas construções de macro.
Para manter o uso do Ruby 2.6 e usar o [Apache thrift](https://github.com/apache/thrift/tree/master/lib/rb) temos de ignorar algumas flags. Para isso podemos rodar:

```bash
bundle config build.thrift --with-cppflags="-Wno-compound-token-split-by-macro"
#bundle config set build.thrift --with-cppflags="-Wno-compound-token-split-by-macro"
bundle install
```

Ou na linha de comando instalando a gem diretamente:

```bash
gem install thrift -- --with-cppflags="-Wno-compound-token-split-by-macro"
```


Esse comando vai gerar (ou atualizar) o arquivo `.bundle/config` no projeto com algo assim:

```yaml
---
BUNDLE_BUILD__THRIFT: --with-cppflags=-Wno-compound-token-split-by-macro
```

##### Ferramentas de desenvlvimento no macOS

As vezes precisamos atualizar as ferramentas como compiladores no mac:

```bash
xcode-select --install

# Verifiquei as versões dos compiladores instalados:
clang --version
make --version
```

## Testes funcionais, de integração e de aceitação

A suíte usa RSpec e Rack::Test, já presentes no projeto, sem novas gems. Não há
testes unitários: as requisições atravessam Sinatra, templates e middlewares reais.

```bash
bundle install
bundle exec rspec
```

- `spec/requests`: respostas HTTP, criação e listagem de fotos, detalhe, IDs
  inválidos, CSS, documentação e contrato OpenAPI.
- `spec/features`: jornadas de visitante pelo formulário, links, redirecionamentos
  e retorno à galeria, exercitadas pela interface HTTP.
- `spec/integration`: spans da pilha HTTP, propagação de contexto, status de erro
  e exportação OTLP para um coletor HTTP local simulado, com respostas 200 e 400.

Cada cenário começa com uma coleção vazia e contador reiniciado, recarregando
as rotas que guardam o estado em memória. A ordem dos testes é aleatória; para
reproduzir uma execução, use `bundle exec rspec --seed NUMERO`.

O ambiente `test` é definido antes de carregar a aplicação. A exportação automática
para serviços externos é desativada, e um exporter em memória recebe os spans reais.
O transporte Net::HTTP é bloqueado para destinos externos. O coletor simulado usa
WEBrick na interface loopback, com porta aleatória e encerramento após cada teste.
Os testes verificam o payload protobuf realmente enviado pelo exporter OTLP,
incluindo compressão, sem credenciais nem acesso a um coletor externo.

O servidor apenas renderiza as URLs do Unsplash; ele não baixa as imagens.
Rack::Test não executa JavaScript nem baixa imagens, fontes ou scripts do Swagger UI.
Esses recursos são verificados no HTML, sem consultar terceiros. Não são necessárias
cassettes VCR. Validação visual e execução em navegador real não fazem parte da suíte.

Há uma pendência explícita no cenário de propagação de `traceparent` com Ruby 2.6.2
e `opentelemetry-common` 0.19.7: o getter da dependência tenta modificar uma string
congelada. O cenário usa `pending` e continua executando as asserções: uma correção
que faça o cenário passar exige remover a marcação de pendência.

### Relatório no CI

O [pipeline de pull requests](.github/workflows/pull-request.yaml) valida o tipo
do PR e executa testes, SAST e análise de dependências em paralelo. O code review
automatizado recebe todos os resultados antes de publicar sua decisão formal.
O check **PR gate** consolida as etapas e deve ser o único obrigatório no ruleset.
Veja a [sequência, política de review e configuração](docs/automated-code-review.md).

Os testes mostram o nome de cada cenário nos logs e no Dorny. O JSON nativo do
RSpec é convertido para JUnit por `script/rspec_to_junit.rb`, usando apenas a
biblioteca padrão do Ruby. Os relatórios ficam disponíveis como artefatos mesmo
quando testes falham. PRs de forks recebem os artefatos; a publicação de Checks
pelo Dorny usa token de escrita somente em PRs do próprio repositório.
O workflow de testes também continua no push da `master` e por acionamento manual.

Para gerar os relatórios localmente (execute a conversão mesmo se houver falhas):

```bash
mkdir -p tmp/test-results
bundle exec rspec --format documentation --format json --out tmp/test-results/rspec.json
bundle exec ruby script/rspec_to_junit.rb tmp/test-results/rspec.json tmp/test-results/rspec.xml
```
