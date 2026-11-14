FROM ruby:3.1.6
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /myapp
WORKDIR /myapp
# RUN gem install solargraph -v 0.48.0 --no-document
ADD Gemfile /myapp/Gemfile
ADD Gemfile.lock /myapp/Gemfile.lock
RUN gem install foreman
RUN bundle install
ADD . /myapp

EXPOSE 7658
