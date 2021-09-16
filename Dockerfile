FROM ruby:2.7
LABEL maintainer="pete.jc.taylor@hey.com"
RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends nodejs
WORKDIR /app
COPY . /app
RUN bundle install
CMD ["bin/rails", "s", "-b", "0.0.0.0"]