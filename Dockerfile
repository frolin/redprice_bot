FROM ruby:3.0.1-alpine AS ruby_base

RUN apk add --update --no-cache \
      binutils-gold \
      build-base \
      curl \
      file \
      g++ \
      gcc \
      git \
      less \
      libstdc++ \
      libffi-dev \
      libc-dev \
      linux-headers \
      libxml2-dev \
      libxslt-dev \
      libgcrypt-dev \
      make \
      netcat-openbsd \
      openssl \
      pkgconfig \
      postgresql-dev \
      python \
      tzdata

COPY Gemfile Gemfile.lock ./

WORKDIR /app

RUN gem install bundler
RUN bundle check || bundle install

EXPOSE 3000

COPY . ./

ENTRYPOINT ["./entrypoints/docker-entrypoint.sh"]