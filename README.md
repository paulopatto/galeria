# Gallery web app

Exemplo de aplicação de uma aplicação web para exemplos de deploy.
Essa aplicação foi desenvolvia no curso de deploy com Heroku da Udacity;
Fiz algumas alterações na aplicação para dar um treinamento de deploy no Heroku
no ChefsClub.com.br e depois foi usado para provas de conceito de infra estrtura
com Elastic BeanStalk por exemplo.

------

## Desenvolvimento com agentes de IA

Consulte o [AGENTS.md](AGENTS.md) para arquitetura, comandos e convenções do
projeto. A pasta [.agents/](.agents/README.md) contém o guia de uso de todas
as skills do projeto: planejamento, implementação, TDD, PR e revisão; as
coleções Ponytail e Caveman; uma skill local Ruby/Sinatra; e perfis de
desenvolvimento, testes e revisão. A origem e a licença das skills estão
documentadas em [.agents/SOURCES.md](.agents/SOURCES.md).

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
