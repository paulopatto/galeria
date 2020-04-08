FROM ruby:2.6.2-alpine
RUN apk update && apk upgrade

ENV APP_HOME=/var/www/galeria
RUN mkdir -p $APP_HOME
ADD . $APP_HOME/
WORKDIR $APP_HOME
RUN gem install foreman
RUN bundle install
