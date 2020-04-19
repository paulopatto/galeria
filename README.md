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

### Via docker V1.0

Construa com: `docker build --tag galeria:1.0`
Execute com: `docker run --publish 9000:9000 --name galeria-web galeria:1.0`
