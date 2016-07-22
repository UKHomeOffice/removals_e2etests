# End to End Feature & Performance Tests

[![Build](https://travis-ci.org/UKHomeOffice/removals_e2etests.png)](https://travis-ci.org/UKHomeOffice/removals_e2etests)

There are two ways to run the tests, if you want to just get started quickly then use docker, if you want to integrate this into your IDE for example you might prefer to run the code on your machine.

## Running the code on your machine:
```shell
# Install nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | bash
source ~/.nvm/nvm.sh

# Install & Use Node 4.2
nvm install 4.2
nvm use 4.2
cd removals_e2etests/nightwatch
npm install
```

## Run tests against an environment
```shell
# Start the [FE Application] (https://github.com/UKHomeOffice/removals_wallboard)
cd removals_wallboard
gulp dev

# Start the [API Application] (https://github.com/UKHomeOffice/removals_integration)
cd removals_integration
PORT=8080 npm start

# Run the e2e tests locally
cd removals_e2etests/nightwatch
./test.sh

# Setup the keycloak credentials file & Run the e2e tests against a remote environment
cd removals_e2etests
echo "KEYCLOAK_USER=myusername
KEYCLOAK_PASS=mypassword" > mycredentials

cd removals_e2etests/nightwatch
./test.sh [docker|dev|int|uat]
```

##Run e2e tests against a local environment with docker-compose
```shell
# Build the [API Application] (https://github.com/UKHomeOffice/removals_integration)
cd removals_integration
docker build -t removals_integration .

# Build the [FE Application] (https://github.com/UKHomeOffice/removals_wallboard)
cd removals_wallboard
docker build -t removals_wallboard .

# Run tests
./runtests.sh --env docker
```

## Run e2e tests against a remote environment with docker-compose
```shell
# Setup the keycloak credentials file
cd removals_e2etests
echo "KEYCLOAK_USER=myusername
KEYCLOAK_PASS=mypassword" > mycredentials

# Run the e2e tests
./runtests.sh --env [dev|int|uat]
```

## Run e2e performance tests against a remote environment with docker-compose
```shell
# Setup the keycloak credentials file
cd removals_e2etests
echo "KEYCLOAK_USER=myusername
KEYCLOAK_PASS=mypassword" > mycredentials

# Run performance tests
./runtests.sh --env [docker|dev|int|uat] --tag performance
```

## Run e2e tests against an environment with IntelliJ
```shell
# Add a new Node.js Configuration setting
```
![Alt text](/images/intellij_settings_to_run_e2etests.png?raw=true "Run e2e tests against an environment with IntelliJ")

## Run e2e performance tests against a remote environment with IntelliJ
```shell
# Comment out line 66 in e2e_tests/nightwatch/nightwatch.conf.js:
//skiptags: _.pullAll(['performance', 'wip'], process.argv),

# Add a new Node.js Configuration setting
```
![Alt text](/images/intellij_settings_to_run_e2e_performance_tests.png?raw=true "Run e2e performance tests against an environment with IntelliJ")

## IBM Environments
| env | backend | frontend |
| --- | ------- | -------- |
| default | http://localhost:8080 | http://localhost:8000 |
| docker | http://backend | http://frontend |
| dev | https://api-ircbd-dev.notprod.homeoffice.gov.uk | https://wallboard-ircbd-dev.notprod.homeoffice.gov.uk |
| int | https://api-ircbd-int.notprod.homeoffice.gov.uk | https://wallboard-ircbd-int.notprod.homeoffice.gov.uk |
| uat | https://api-ircbd-uat.notprod.homeoffice.gov.uk | https://wallboard-ircbd-uat.notprod.homeoffice.gov.uk |
