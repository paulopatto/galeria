# Gallery web app

Exemplo de aplicação de uma aplicação web para exemplos de deploy.
Essa aplicação foi desenvolvia no curso de deploy com Heroku da Udacity;
Fiz algumas alterações na aplicação para dar um treinamento de deploy no Heroku
no ChefsClub.com.br e depois foi usado para provas de conceito de infra estrtura
com Elastic BeanStalk por exemplo.

------

## Como executar esse projeto

### Desenvolvimento

- 1. Instalar dependencias: `bundle install`
- 2. Chamar a linha de comando para rodar o servidor rack: `PORT=9000 bundle exec rackup ./config.ru -p $PORT`
- 3. Acesse http://localhost:9000/

### Via docker V1.0.x

Construa com: `docker build --tag galeria:1.0`
Execute com: `docker run --publish 9000:9000 --name galeria-web galeria:1.0`


### Otel

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