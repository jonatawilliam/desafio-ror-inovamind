FROM ruby:2.6.3

RUN apt-get update && apt-get install -qq -y --no-install-recommends nano

ENV INSTALL_PATH /desafio-ror-inovamind

RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

ENV BUNDLE_PATH /gems

COPY . .