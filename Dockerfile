FROM ruby:3.0.1-alpine AS ruby_base

ENV APP_HOME="/red_price_bot"
RUN apk --no-cache add \
     build-base tzdata openrc coreutils imagemagick \
    curl tar git bash  openssh-client pv less mc vim \
    postgresql-dev postgresql-client \
    nodejs npm

#COPY ./.bashrc /root

WORKDIR $APP_HOME

RUN gem install bundler

EXPOSE 3000
