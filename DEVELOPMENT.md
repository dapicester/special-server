How to setup the development environment
===

Install Ruby
---

Use [RVM](https://rvm.io/) to install and manage Ruby.
Verify that Ruby 2.0.0 is installed

    $ ruby -v

If not, install it

    $ rvm get head
    $ rvm reload
    $ rvm install 2.0.0
    $ rvm use --default 2.0.0

Set up integration with Bundler

    $ chmod +x $rvm_path/hooks/after_cd_bundler

Checkout the code
---

 1. Clone the repository

        $ git clone git@git.assembla.com:special-server.git
        $ cd special-server

    or pull the last version

        $ git pull

 2. Switch to the `develop` branch (or whatever branch you need)

        $ git checkout develop

 3. Install requirements

        $ bundle install --without production mac

    if on Linux, otherwise

        $ bundle install --without production linux

    if on Mac OS.

   * It may be required to install some libraries
   * The `--without` option is required only the first time

 4. Create and update the database

        $ rake db:create
        $ rake db:migrate

    Before testing, align the test databases

        $ rake db:test:prepare

    In case of database problems, reset everything

        $ rake db:reset

 5. Run tests

        $ rspec

    Then, it is also possible to browse coverage results
    in `coverage/index.html`.

Development Session
---

 1. Launch Guard for file monitoring

        $ guard

 2. Hack the code!
    When a file change is detected, related tests run _automatically_.

    * Note: sometimes may be required to reload Guard

### Git-flow model

Any developer should work on its local feature branch.
When the feature is completed it can be merged into the `develop` branch.
The `master` branch _shall_ not be used, it will be updated during the
release process.
The `git-flow` plugin greatly simplifies dealing with this model.

References:

- [A successful Git branching model](http://nvie.com/posts/a-successful-git-branching-model/)
- [Why aren't you using git-flow?](http://jeffkreeftmeijer.com/2010/why-arent-you-using-git-flow/)
- [On the path with git-flow](http://codesherpas.com/screencasts/on_the_path_gitflow.mov)

### Test Driver Development

It is strongly suggested to follow the Red-Green coding, that is:

 1. Write a test case for the to-be-developed function
 2. Ensure that test fails (Red)
 3. Write the code for new function until test passes (Green)

