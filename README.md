# LTF

Embedded Linux System Test Framework

## HOWTO

* go to the folder of a testcase/testsuite

* `make testconfig`
    - generate `testconfig.mk`
    - you can edit `testconfig.mk` to choose a target from folder `targets`

* `make setup`
    - install compontents this case required on the target
    - you can also use like `make setup TESTTARGET=demo1` to specify target `demo1`

* `make test`
    - test the testcase/testsuite

* `make teardown`
    - uninstall compontents
    - recover the status before test

## Running on Docker

* Build the base image.

```
docker build -t env-for-ltf .
```

* Run container for LTF

```
docker run \
-it `#Interactive with console` \
--rm `#Automatically remove container when it exits` \
-v $(pwd):/work/LTF `#Mount icomd directory` \
-w /work/LTF `#Set initial directory` \
env-for-ltf
```

## Repository description

Top level of repository can be divided into the following directories:

* `analyzers`
    - `default` - include the default value of some environment variables
    - `test-analyzer`- it can be used to provide global environment variables
* `bin`
    - `cmds` - include the wrappers of some useful shell commonds
    - `flags` - include some debug flags
    - `defaultgoal-xxx` - the commonds which can be called by MAKE
* `components`
    - `install` - (will be used to install the new SW load into target)
    - `setup` - the components which will be installed into target when `make setup`
    - `teardown` - the components which will be uninstalled from target when `make teardown`
* `mkfiles` - some makefiles needed to be imported
* `src` - some external repositories
    - `buildroot` - (will be used for target tools generation)
    - `envparser` - pylib to add, delete, replace ENV
    - `lcov` - (will be used for coverage)
    - `testhelper` - for unified communication with target
* `targets` - some targets
* `tests` - some tests running on the targets
    - `example` - show some functions of LTF
