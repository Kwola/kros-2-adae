FROM ruby:2.3
MAINTAINER davidmuirdesign@gmail.com
LABEL maintainer="David <davidmuirdesign@gmail.com>"

WORKDIR /adae-docker
COPY . ./

#check to make sure bundle is there
RUN bundle -v

RUN gem install rubygems-update

RUN gem install rails -v 3.1.12

#check the ruby version
RUN ruby -v

RUN rails -v

EXPOSE 3000

RUN gem install therubyracer

#RUN bundle install 
#install node js for javascript dependencies
RUN bundle install \
    && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt install -y nodejs

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
