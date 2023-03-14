`jekyll_outline`
[![Gem Version](https://badge.fury.io/rb/jekyll_outline.svg)](https://badge.fury.io/rb/jekyll_outline)
===========

`jekyll_outline` Jekyll tag plugin that creates a clickable table of contents.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jekyll_outline'
```

And then execute:

    $ bundle install


### CSS
The CSS used for the demo website should be copied to your project.
See the section of `demo/assets/css/styles.css` as shown:

```css
/* Start of jekyll_outline css */
  ... copy this portion ...
/* End of jekyll_outline css */
```

## Additional Information
More information is available on
[Mike Slinn&rsquo;s website](https://www.mslinn.com/jekyll/3000-jekyll-plugins.html#outline).


## Development

After checking out the repo, run `bin/setup` to install dependencies.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

Install development dependencies like this:
```
$ BUNDLE_WITH="development" bundle install
```

To build and install this gem onto your local machine, run:
```shell
$ bundle exec rake install
jekyll_outline 0.1.0 built to pkg/jekyll_outline-0.1.0.gem.
jekyll_outline (0.1.0) installed.

$ gem info jekyll_outline

*** LOCAL GEMS ***

jekyll_outline (0.1.0)
    Author: Mike Slinn
    Homepage:
    https://github.com/mslinn/jekyll_outline
    License: MIT
    Installed at: /home/mslinn/.gems

    Generates Jekyll logger with colored output.
```


## Test
A test website is provided in the `demo` directory.
 1. Set breakpoints.

 2. Initiate a debug session from the command line:
    ```shell
    $ bin/attach demo
    ```

  3. Once the `Fast Debugger` signon appears, launch the Visual Studio Code launch configuration called `Attach rdebug-ide`.

  4. View the generated website at [`http://localhost:4444`](http://localhost:4444)


## Release
To release a new version,
  1. Update the version number in `version.rb`.
  2. Describe the changes in `CHANGELOG.md`.
  3. Commit all changes to git; if you don't the next step might fail with an unexplainable error message.
  4. Run the following:
     ```shell
     $ bundle exec rake release
     ```
     The above creates a git tag for the version, commits the created tag,
     and pushes the new `.gem` file to [RubyGems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mslinn/jekyll_outline.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
