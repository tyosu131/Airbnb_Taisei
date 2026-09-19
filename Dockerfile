FROM node:14.21.3-bullseye-slim AS frontend_runtime

FROM ruby:3.3.8-bookworm

ENV LANG=C.UTF-8

RUN set -eux; \
    apt-get update -o Acquire::Retries=5 -qq; \
    apt-get install -y --no-install-recommends \
      build-essential \
      default-libmysqlclient-dev \
      ca-certificates; \
    rm -rf /var/lib/apt/lists/*

# Webpacker 4 pins node-sass 4, whose last supported Node release is Node 14.
# Copy the exact legacy runtime (including Yarn Classic) without depending on
# Bullseye's retired apt repositories. Remove this stage with the frontend
# modernization rather than silently moving an incompatible native dependency.
COPY --from=frontend_runtime /usr/local/ /usr/local/

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
