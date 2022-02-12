FROM ruby:3.0.1-alpine AS ruby_base

ENV APP_HOME="/redprice_bot"
RUN apk --no-cache add \
     build-base tzdata openrc coreutils imagemagick \
    curl tar git bash openssh-client pv less mc vim nano \
    postgresql-dev postgresql-client

#COPY ./.bashrc /root

WORKDIR $APP_HOME

RUN gem install bundler
RUN bundle install

EXPOSE 3000
