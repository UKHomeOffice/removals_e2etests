FROM quay.io/ukhomeofficedigital/nodejs-base:v6.9.1

WORKDIR /home/app

ADD nightwatch/package.json nightwatch/npm-shrinkwrap.json ./

RUN npm install
COPY nightwatch/. .
ENV PATH=${PATH}:./node_modules/.bin
