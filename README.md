# KC Preparer

_For all your KC-Preparin' needs!_

This gem is meant to be run as part of a [Travis CI](https://travis-ci.org/) build of the KC github repository.

## Getting Started

Add a file called `.travis.yml` into the root of the github repository:

    language: ruby

    rvm:
      - 2.2.3

    branches:
      only:
        - master

    env:
      global:
        - KC_DOC_ROOT=<path/to/doc/root>
        - KC_BASE_URL=<http://example.com/kc>
        - NEXUS_URL=<nexus url>
        - secure: <NEXUS_API_KEY encrypted string>
        - secure: <GITHUB_API_TOKEN encrypted string>

    install:
        - gem install specific_install
        - gem specific_install git@github.com:rackerlabs/rackspace-howto-preparer.git

    script:
        - kc-preparer

### Parameters

  - **KC_DOC_ROOT** - Relative directory where the publishable markdown docs live
  - **KC_BASE_URL** - Base URL for the KC docs
  - **NEXUS_URL** - URL of the nexus repository to ship to
  - **NEXUS_API_KEY** - API key for the nexus repository.  This _must_ be encrypted, see the [Travis CI docs on Encryption](http://docs.travis-ci.com/user/encryption-keys) for more information.
  - **GITHUB_API_TOKEN** - API token from github, _must_ be encrypted.

## Developer Setup

Install RVM:

    curl -sSL https://get.rvm.io | bash -s stable --ruby

And then add this line to your ~/.bash_profile or equivalent:

    source /Users/[username]/.rvm/scripts/rvm

Now to install the app:

    rvm install 2.2.3 --with-opt-dir=/usr/bin
    rvm use 2.2.3@kc-preparer --create
    gem install bundler
    bundle install

Whenever you need to work on the app:

    rvm use 2.2.3@kc-preparer

running the tests is as simple as:

    rake
