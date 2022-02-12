FROM ruby:3-alpine AS ruby_base

RUN apk --no-cache add \
     build-base tzdata openrc coreutils imagemagick \
    curl tar git bash  openssh-client pv less mc vim \
    postgresql-dev postgresql-client \
    nodejs npm

#COPY ./.bashrc /root

WORKDIR $APP_HOME

RUN gem install bundler

EXPOSE 3000
