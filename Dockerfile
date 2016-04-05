FROM quay.io/ukhomeofficedigital/selenium-standalone-server:v0.1.2

USER root
RUN yum install -y \
        ruby \
        rubygem-bundler \
        ruby-devel \
        gcc \
        zlib \
        zlib-devel \
        lsof


# install node js
RUN mkdir -p /code/end_to_end_tests /root/Projects/removals/removals_schema /opt/nodejs
WORKDIR /opt/nodejs
RUN curl https://nodejs.org/dist/v4.2.2/node-v4.2.2-linux-x64.tar.gz | tar xz --strip-components=1
ENV PATH=${PATH}:/opt/nodejs/bin


# get the schema for the tests to use
WORKDIR /root/Projects/removals/removals_schema
RUN curl -L https://github.com/UKHomeOffice/removals_schema/archive/RELEASE/0.1.3.tar.gz | tar xz --strip-components=1
RUN npm install


#setup the cucumber tests and the dependencies
WORKDIR /code/end_to_end_tests
COPY end_to_end_tests/Gemfile end_to_end_tests/Gemfile.lock ./
RUN bundle install --binstubs ./bin
COPY end_to_end_tests/ ./

CMD Xvfb $DISPLAY -screen 0 1280x1024x24 & ./pre-hook.rb; ./bin/cucumber -r features -f pretty -f html -o tmp/report${TEST_ENV_NUMBER}.html -t ~@wip