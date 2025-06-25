FROM ruby:2.6.2-alpine

ENV PORT=9000
ENV RACK_ENV=production
ENV APP_HOME=/galeria

RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

COPY Gemfile* $APP_HOME/

RUN bundle install --deployment --without development test

COPY . $APP_HOME/
# ENTRYPOINT $APP_HOME
CMD ["bundle", "exec", "foreman", "start", "web"]
