# End to End tests 

## Install nvm:
```
$ curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | bash
```

#### Install Node
```
$ nvm install 4.2
$ nvm use 4.2
```

### NPM install
```
$ npm install
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
$ node_modules/.bin/nightwatch
```


# testing dev

```shell
$ ./runtests.sh --env dev
```

# testing int

```shell
$ ./runtests.sh --env int
```

# testing dev

```shell
$ ./runtests.sh --env uat
```
