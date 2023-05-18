`jekyll_outline`
[![Gem Version](https://badge.fury.io/rb/jekyll_outline.svg)](https://badge.fury.io/rb/jekyll_outline)
===========

`jekyll_outline` Jekyll tag plugin that creates a clickable table of contents.


## Installation
Add the following line to your Jekyll project's Gemfile, within the `jekyll_plugins` group:

```ruby
group :jekyll_plugins do
  gem 'jekyll_outline'
end
```

And then execute:

    $ bundle


### CSS
The CSS used for the demo website should be copied to your project.
See the sections of [`demo/assets/css/styles.css`](/mslinn/jekyll_outline/blob/master/demo/assets/css/style.css#L252-L315) as shown:

```css
/* Start of jekyll_plugin_support css */
... copy this portion ...
/* End of jekyll_plugin_support css */

/* Start of jekyll_outline css */
  ... copy this portion ...
/* End of jekyll_outline css */
```

### JavaScript
This project's `outline_js` tag returns the Javascript necessary to position images relating to the outline.
If used without parameters it just returns the JavaScript.
Use the tag this way:

```html
<script>
  {%= outline_js %}
</script>
```

If passed the `wrap_in_script_tag` parameter, it wraps the JavaScript in `<script></script>`.
Use the tag this way:

```html
{% outline_js wrap_in_script_tag %}
```


## Explanation
Given an outline that looks like this:
```html
{% outline stuff %}
000: Topic 0..19
020: Topic 20..39
040: Topic 40..
{% endoutline %}
```

...and given pages in the `stuff` collection with the following names:

 - `010-published.html` has title **Published Stuff Post 010**
 - `020-unpublished.html` has title **Unpublished Post 020**
 - `030-unpublished.html` has title **Unpublished Post 030**

Then links to the pages in the `stuff` collection's pages are interleaved into the generated outline like this:
```html
<div class="outer_posts">
  <h3 class='post_title clear' id="title_0">Topic 0..19</h3>
  <div id='posts_wrapper_0' class='clearfix'>
    <div id='posts_0' class='posts'>
      <span>2022-04-01</span> <span><a href='/stuff/010-published.html'>Published Stuff Post 010</a></span>
      <span>2022-04-17</span> <span><a href='/stuff/020-unpublished.html'>Unpublished Post 020</a> <i class='jekyll_draft'>Draft</i></span>
    </div>
  </div>
  <h3 class='post_title clear' id="title_20">Topic 20..39</h3>
  <div id='posts_wrapper_20' class='clearfix'>
    <div id='posts_20' class='posts'>
      <span>2022-04-17</span> <span><a href='/stuff/030-unpublished.html'>Unpublished Post 030</a> <i class='jekyll_draft'>Draft</i></span>
    </div>
  </div>
</div>
```

The JavaScript searches for images in the current page that were created by the
[`img`](https://github.com/mslinn/jekyll_img) tag plugin,
and have `id`s that correspond to outline sections.

Each of following image's `id`s have an `outline_` prefix, followed by a number, which corresponds to one of the sections.
Note that leading zeros in the first column above are not present in the `id`s below.

If you want to provide images to embed at appropriate locations within the outline,
wrap them within an invisible `div` so the web page does not jump around as the images are loaded.
```html
<div style="display: none;">
{% img align="right"
  id="outline_0"
  size="quartersize"
  src="/assets/images/porcelain_washbasin.webp"
  style="margin-top: 0"
  wrapper_class="clear"
%}
{% img align="right"
  id="outline_20"
  size="quartersize"
  src="/assets/images/pipes.webp"
  style="margin-top: 0"
  wrapper_class="clear"
%}
{% img align="right"
  id="outline_40"
  size="quartersize"
  src="/assets/images/libgit2.webp"
  style="margin-top: 0"
  wrapper_class="clear"
%}
</div>
```
The JavaScript identifies the images and repositions them in the DOM such that they follow the appropriate heading.
If no image corresponds to a heading, no error or warning is generated.
The images can be located anywhere on the page; they will be relocated appropriately.
If an image does not correspond to a heading, it is deleted.



## Attribution
See [`jekyll_plugin_support` for `attribution`](https://github.com/mslinn/jekyll_plugin_support#subclass-attribution)


## Additional Information
More information is available on
[Mike Slinn&rsquo;s website](https://www.mslinn.com/jekyll/3000-jekyll-plugins.html#outline).


## Development
After checking out the repo, run `bin/setup` to install development dependencies.
Then you can run `bin/console` for an interactive prompt that will allow you to experiment with `irb`.

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


## Demo
A demo / test website is provided in the `demo` directory.
It can be used to debug the plugin or to run freely.

### Run Freely
 1. Run from the command line:
    ```shell
    $ demo/_bin/debug -r
    ```

  2. View the generated website at [`http://localhost:4444`](http://localhost:4444)

### Plugin Debugging
 1. Set breakpoints in Visual Studio Code.

 2. Initiate a debug session from the command line:
    ```shell
    $ demo/_bin/debug
    ```

  3. Once the `Fast Debugger` signon appears, launch the Visual Studio Code launch
     configuration called `Attach rdebug-ide`.

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
