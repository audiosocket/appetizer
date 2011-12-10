# Appetizer

A lightweight init process for Rack apps.

## Assumptions

* Running Ruby 1.9.2 or better.
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

## License (MIT)

Copyright 2011 Audiosocket (tech@audiosocket.com)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
