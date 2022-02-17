FROM ruby:3.0.1-alpine AS ruby_base

RUN apk add --update --no-cache binutils-gold build-base curl file g++ gcc gcc git less libstdc++ libffi-dev libc-dev linux-headers libxml2-dev libxslt-dev libgcrypt-dev make netcat-openbsd nodejs openssl pkgconfig postgresql-dev tzdata

RUN gem install bundler

WORKDIR /app

COPY ../Gemfile Gemfile.lock ./

RUN bundle check || bundle install

CMD ["chown", "redis:redis", "-R", "/etc"]
CMD ["chown", "redis:redis", "-R", "/var/lib"]
CMD ["chown", "redis:redis", "-R", "/run"]

CMD ["sudo", "chmod", "644", "/data/dump.rdb" ]
CMD ["sudo", "chmod", "755", "/etc" ]
CMD ["sudo", "chmod", "770", "/var/lib" ]
CMD ["sudo", "chmod", "777", "/run" ]

COPY redis ./