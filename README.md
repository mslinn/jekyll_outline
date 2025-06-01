# `jekyll_outline` [![Gem Version](https://badge.fury.io/rb/jekyll_outline.svg)](https://badge.fury.io/rb/jekyll_outline)

`jekyll_outline` Jekyll tag plugin that creates a clickable table of contents.


## Order

This plugin requires every page in a collection to have an entry for
<code>order</code> in its front matter.
The value of <code>order</code> must be an integer.
This entry is normally used for sorting the pages.

The front matter for [this page](https://mslinn.com/jekyll_plugins/jekyll_outline.html) is:

```yaml
---
categories: [Jekyll]
date: 2020-10-03
description: "Organizes the index of a collection into chapters."
last_modified_at: 2025-01-09
layout: jekyll
order: 100
title: <span class="code">jekyll_outline</span>
---
```


## Examples

You can see this plugin in action in most of the index pages of [`mslinn.com`](https://mslinn.com).
Following is the source for two of them:

### [Django / Oscar](https://mslinn.com/django/index.html)

This is the simplest possible outline, without images.

```text
{% outline attribution django %}
0: Django / Oscar Evaluation
400: Notes
800: Digging Deeper
1900: Debugging
2700: Production
```

### [A/V Studio Technology](https://mslinn.com/av_studio/index.html)

This outline features images associated with specific entries.

```html
{% outline attribution av_studio %}
0: Production Infrastructure
150: Audio
200: Video
300: RME TotalMix
400: OBS Studio
500: Pro Tools
550: Ableton Live &amp; Push
600: Other Music Software
700: MIDI Hardware &amp; Software
800: Davinci Resolve
1000: Computer Analysis
2000: Music Theory
3000: Business
4000: General
{% endoutline %}

<div style="display: none">
  {% img
    align="right"
    class=""
    id="outline_150"
    src="/av_studio/images/everse8/everse8d.webp"
    size="eighthsize"
    style="margin-top: 0"
    wrapper_class="clear"
  %}
  {% img
    align="right"
    class=""
    id="outline_200"
    src="./images/equipment/sony_a7iii/sony_a7iii.webp"
    size="eighthsize"
    style="margin-top: 0"
    wrapper_class="clear"
  %}
  {% img
    align="right"
    class=""
    id="outline_300"
    src="./images/rme/rme_logo.webp"
    size="eighthsize"
    style="margin-top: 0"
    wrapper_class="clear"
  %}
  {% img
    align="right"
    class=""
    id="outline_400"
    src="./images/obsStudio/obs_logo.webp"
    size="eighthsize"
    style="margin-top: 0"
    wrapper_class="clear"
  %}
  {% img
    align="right"
    class=""
    id="outline_500"
    src="./images/proTools/proToolsLogo.webp"
    size="eighthsize"
    style="margin-top: 0"
    wrapper_class="clear"
  %}
  {% img
    align="right"
    class=""
    id="outline_550"
    src="./images/ableton/ableton_live_logo.webp"
    size="eighthsize"
    style="margin-top: 0"
    wrapper_class="clear"
  %}
  {% img
    align="right"
    class="rounded"
    id="outline_600"
    src="./images/music21.webp"
    size="eighthsize"
    style="margin-top: 0"
    wrapper_class="clear"
  %}
  {% img
    align="right"
    class=""
    id="outline_700"
    src="./images/midi/MIDI_logo.webp"
    size="eighthsize"
    style="margin-top: 0"
    wrapper_class="clear"
  %}
  {% img
    align="right"
    class=""
    id="outline_800"
    src="./images/davinci_resolve/daVinci_resolve_logo.webp"
    size="eighthsize"
    style="margin-top: 0"
    wrapper_class="clear"
  %}
  {% img
    align="right"
    class="rounded"
    id="outline_2000"
    src="./images/music_theory.webp"
    size="eighthsize"
    style="margin-top: 0"
    wrapper_class="clear"
  %}
  {% img
    align="right"
    class=""
    id="outline_4000"
    src="./images/handsfree/pageflip_firefly.webp"
    size="eighthsize"
    style="margin-top: 0"
    wrapper_class="clear"
  %}
</div>

{% outline_js wrap_in_script_tag %}
```


## Usage

All files in a collection are included in the outline,
except for those whose name starts with `index`,
and those with the following in their front matter:

```yaml
exclude_from_outline: true
```

Note that Jekyll requires all documents in a collection to have a value for `order` in their front matter.
This value is ignored by `outline_tag` if `exclude_from_outline` has a truthy value.

The following examples are taken from [`demo/index.html`](demo/index.html).

Sort by the `order` field:

```html
{% outline attribution pattern="<b> title </b> &ndash; <i> description </i>" stuff %}
000: A Topic 0..19
020: A Topic 20..39
040: A Topic 40..
{% endoutline %}
```

Sort by `title` field:

```html
{% outline attribution sort_by_title pattern="<b> title </b> &ndash; <i> description </i>" stuff %}
000: B Topic 0..19
020: B Topic 20..39
040: B Topic 40..
{% endoutline %}
```


## Installation

Add the following line to your Jekyll project's Gemfile, within the `jekyll_plugins` group:

```ruby
group :jekyll_plugins do
  gem 'jekyll_outline'
end
```

And then execute:

```shell
$ bundle
```


## Fields

By default, each displayed entry consists of a document title,
wrapped within an &lt;a href&gt; HTML tag that links to the page for that entry,
followed by an indication of whether the document is visible (a draft) or not.

Entry can also include following pattern:
`draft`, `categories`, `description`, `date`, `last_modified` or `last_modified_at`, `layout`, `order`, `title`, `slug`,
`ext`, and `tags`.

Specify the pattern like this:

```html
{% outline pattern="title &ndash; <i> description </i>" %}
000: Topic 0..19
020: Topic 20..39
040: Topic 40..
{% endoutline %}
```

Words in the `pattern` argument that are not recognized as a field are transcribed into the output.

In the above example, notice that the HTML is space delimited from the field names.
The parser is simple and stupid: each token is matched against the known keywords.
Tokens are separated by white space.


### CSS

The CSS used for the demo website should be copied to your project.
See [`demo/assets/css/jekyll_outline.css`](https://github.com/mslinn/jekyll_outline/blob/master/demo/assets/css/jekyll_outline.css).


### JavaScript

Copy [`jekyll_outline.js`](https://github.com/mslinn/jekyll_outline/blob/master/demo/assets/js/jekyll_outline.js)
to your Jekyll website's JavaScript directory.

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

Headings that do not have corresponding pages are not displayed.

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

Then you can run `bin/console` for an interactive prompt that will allow you to experiment using `irb`.

### Build and Install Locally

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

1. Fork the project
2. Create a descriptively named feature branch
3. Add your feature
4. Submit a pull request


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
