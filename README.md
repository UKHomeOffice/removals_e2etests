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
### Bundle install
```
$ cd removals_e2e_tests/end_to_end_tests
$ bundle install
```
### To run the tests with the integration app and dashboard app on start-up:
```
$ INTEGRATION_APP=true DASHBOARD_APP=true cucumber -r features --tags ~@wip
```


<!--parallel_test -t cucumber --serialize-stdout features/heart_beat_features/-->