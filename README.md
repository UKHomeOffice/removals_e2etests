# End to End tests 

There are two ways to run the tests, if you want to just get started quickly then use docker, if you want to integrate this into your IDE for example you might prefer to run the code on your machine.


## Running the code on your machine:
```shell
# Install nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | bash
source ~/.nvm/nvm.sh

# Install Node
cd nightwatch
nvm install 4.2
nvm use 4.2
npm install

# Run tests against localhost
./test.sh

# Once you've setup the keycloak credentials file (see bottom)
# ./test.sh [docker|dev|int|uat] will also work
```


## Running the code against a remote environment with docker-compose
```shell
./runtests.sh --env dev
```


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


| env | backend | frontend |
| --- | ------- | -------- |
| default | http://localhost:8080 | http://localhost:8000 |
| docker | http://backend | http://frontend |
| dev | https://api-ircbd-dev.notprod.homeoffice.gov.uk | https://wallboard-ircbd-dev.notprod.homeoffice.gov.uk |
| int | https://api-ircbd-int.notprod.homeoffice.gov.uk | https://wallboard-ircbd-int.notprod.homeoffice.gov.uk |
| uat | https://api-ircbd-uat.notprod.homeoffice.gov.uk | https://wallboard-ircbd-uat.notprod.homeoffice.gov.uk |


## When testing against remote environments
Its important to define the following environment variables

| Environment variable | Meaning |
| -------------------- | ------- |
| KEYCLOAK_USER | username to use when authenticating with keycloak |
| KEYCLOAK_PASS | password to use when authenticating with keycloak |

When using docker you can add a `mycredentials` file to the route e.g.:

```shell
echo "KEYCLOAK_USER=myusername
KEYCLOAK_PASS=mypassword" > mycredentials
```
