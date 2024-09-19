FROM ruby:3.2.2
WORKDIR /app
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install
COPY . /app
