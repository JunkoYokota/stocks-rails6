FROM ruby:2.7.0

# https://yarnpkg.com/lang/en/docs/install/#debian-stable
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update -qq && apt-get install -y nodejs default-mysql-client vim && \
  apt-get install -y yarn && \
  apt-get install -y imagemagick && \
  yarn install -y bootstrap && \
  yarn install -y jquery && \
  yarn install -y popper.js && \
  apt-get install -y libvips-tools && \
  apt-get install -y locales

RUN echo "ja_JP.UTF-8 UTF-8" > /etc/locale.gen && \
  locale-gen ja_JP.UTF-8 && \
  /usr/sbin/update-locale LANG=ja_JP.UTF-8
ENV LC_ALL ja_JP.UTF-8

ENV APP_PATH=/app
RUN mkdir $APP_PATH
WORKDIR $APP_PATH
COPY Gemfile "${APP_PATH}/Gemfile"
COPY Gemfile.lock "${APP_PATH}/Gemfile.lock"
RUN gem install bundler
RUN bundle _2.1.4_ install
COPY . /app

RUN mkdir /root/.vim
COPY .vimrc /root/.vimrc
WORKDIR /root

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
