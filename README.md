# End to End tests 

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

## Run tests against localhost
```shell
# Start the [FE Application] (https://github.com/UKHomeOffice/removals_wallboard)
cd removals_wallboard
gup dev

# Start the [API Application] (https://github.com/UKHomeOffice/removals_integration)
cd removals_integration
PORT=8080 npm start

# Run the e2e tests
cd removals_e2etests/nightwatch
./test.sh
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

# Comment out line 66 in e2e_tests/nightwatch/nightwatch.conf.js:
//skiptags: _.pullAll(['performance', 'wip'], process.argv),

# Run performance tests
./runtests.sh --env [dev|int|uat] --tag performance
```

| env | backend | frontend |
| --- | ------- | -------- |
| default | http://localhost:8080 | http://localhost:8000 |
| docker | http://backend | http://frontend |
| dev | https://api-ircbd-dev.notprod.homeoffice.gov.uk | https://wallboard-ircbd-dev.notprod.homeoffice.gov.uk |
| int | https://api-ircbd-int.notprod.homeoffice.gov.uk | https://wallboard-ircbd-int.notprod.homeoffice.gov.uk |
| uat | https://api-ircbd-uat.notprod.homeoffice.gov.uk | https://wallboard-ircbd-uat.notprod.homeoffice.gov.uk |

## Running the code against a local environment with docker-compose
```shell
# Build the backend
cd backend_codebase
docker build -t ibm-backend .

# Build the frontend
cd frontend_codebase
docker build -t ibm-frontend .

# Run tests
./runtests.sh --env docker
```