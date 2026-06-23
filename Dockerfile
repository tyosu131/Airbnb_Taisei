FROM ruby:3.0.3

ENV LANG=C.UTF-8

RUN set -eux; \
    apt-get update -o Acquire::Retries=5 -qq; \
    apt-get install -y --no-install-recommends \
      build-essential \
      default-libmysqlclient-dev \
      nodejs \
      curl \
      ca-certificates \
      gnupg; \
    rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor -o /usr/share/keyrings/yarn.gpg; \
    echo "deb [signed-by=/usr/share/keyrings/yarn.gpg] https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list; \
    apt-get update -o Acquire::Retries=5 -qq; \
    apt-get install -y --no-install-recommends yarn; \
    rm -rf /var/lib/apt/lists/*

RUN gem install bundler -v 2.3.9

WORKDIR /tmp
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install

ENV APP_HOME=/Airbnb_Taisei
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

COPY . $APP_HOME

RUN yarn install --check-files

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]