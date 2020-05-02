FROM ruby:2.3
MAINTAINER davidmuirdesign@gmail.com
LABEL maintainer="David <davidmuirdesign@gmail.com>"

WORKDIR /adae-docker
COPY . ./

RUN gem install rubygems-update

RUN gem install rails -v 3.1.12

EXPOSE 3000

RUN gem install therubyracer

#RUN bundle install 
#install node js for javascript dependencies
RUN bundle install \
    && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt install -y nodejs

ENTRYPOINT ["sh", "./run.sh"]