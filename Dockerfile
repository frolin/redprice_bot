FROM ruby:3.0.1-alpine AS ruby_base

RUN apk add --update --no-cache binutils-gold build-base curl file g++ gcc gcc git less libstdc++ libffi-dev libc-dev linux-headers libxml2-dev libxslt-dev libgcrypt-dev make netcat-openbsd nodejs openssl pkgconfig postgresql-dev python tzdata

RUN gem install bundler

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle check || bundle install

COPY . ./