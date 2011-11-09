# Appetizer

A lightweight init process for Rack apps.

## Assumptions

* Running Ruby 1.9.2.
* Using Bundler.
* Logging in all envs except `test` is to `STDOUT`. Logging in `test`
  is to `tmp/test.log`.
* Default internal and external encodings are `Encoding::UTF_8`.

## Load/Init Lifecycle

0. Optionally `require "appetizer/{rack,rake}"`, which will
1. `require "appetizer/setup"`, which will
2. `load "config/env.local.rb"` if it exists, then
3. `load "config/env.rb"` if **it** exists.
4. `load "config/env/#{App.env}.rb"` if **it** exists, then
5. App code is loaded, but not initialized.
6. `App.init!` is called. Happens automatically if step 1 occurred.
7. Fire the `initializing` event.
8. `load "config/init.rb"` if it exists.
9. `load "config/{init/**/*.rb"`, then
10. Fire the `initialized` event.
