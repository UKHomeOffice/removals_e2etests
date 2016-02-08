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
### To run tests in parallel. For more information see https://github.com/grosser/parallel_tests
```
$ parallel_test -t cucumber --serialize-stdout --combine-stderr -o '-r features -t ~@wip' features/
```