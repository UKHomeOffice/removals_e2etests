FROM node:4.2.2

ADD nightwatch/package.json package.json
ADD nightwatch/npm-shrinkwrap.json npm-shrinkwrap.json

RUN npm install
COPY nightwatch/. .
ENV PATH=${PATH}:./node_modules/.bin
