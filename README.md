# End to End tests 

## Install rvm:
```
$ \curl -sSL https://get.rvm.io | bash -s stable
```
#### Install Ruby 2.1.7
```
$ rvm install 2.1.7
$ rvm use 2.1.7
```
### Install bundler
```
$ gem install bundler
```
### Clone repository

### Bundle install
```
$ cd removals_e2e_tests/end_to_end_tests
$ bundle install
```
### Setup test env
```
Ensure Dashboard and Integration app are running
$ ./pre-hook.rb
This setups up centres to be used for testing
```

# local testing

### get the backend up and running

```shell
cd backend_codebase
docker build -t be .
docker run -ti --rm --net host --name be -e "NODE_ENV=development" -e "PORT=8080" be
```

### get the front end up and running

```shell
cd frontend_codebase
docker build -t fe .
docker run -ti --rm --net host --name fe -e "BACKEND=http://`docker-machine ip`:8080" -e "KEYCLOAKURL=http://`docker-machine ip`:8000" fe
```

```shell
docker build -t e2e-test . && \
docker run \
    --rm -ti \
    --net host \
    -v `pwd -P`/end_to_end_tests/performance_info:/code/end_to_end_tests/performance_info \
    -v `pwd -P`/end_to_end_tests/tmp:/code/end_to_end_tests/tmp \
    -v `pwd -P`/end_to_end_tests/screenshots:/code/end_to_end_tests/screenshots \
    e2e-test
```


# testing dev

```shell
docker build -t e2e-test . && \
docker run \
    --rm -ti \
    -e "CONFIG_FILE=features/support/config-dev.yml" \
    -v `pwd -P`/end_to_end_tests/performance_info:/code/end_to_end_tests/performance_info \
    -v `pwd -P`/end_to_end_tests/tmp:/code/end_to_end_tests/tmp \
    -v `pwd -P`/end_to_end_tests/screenshots:/code/end_to_end_tests/screenshots \
    e2e-test
```
