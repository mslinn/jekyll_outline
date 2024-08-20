# Change Log

## 1.2.5 / 2024-08-20

* Added configurable error handling
* Updated to jekyll_plugin_support v1.0.2
* Defined `outline_error` CSS class in `demo/assets/css/jekyll_outline.css`.


## 1.2.4 / 2024-07-23

* Updated dependencies to rely on current `jekyll_draft`.
* Removes any leading whitespace in plugin content so the YAML is more likely to be well-formed.
* Handles poorly formed whitespace gracefully.


## 1.2.3 / 2024-07-23

* Made compatible with jekyll_plugin_support v1.0.0


## 1.2.2 / 2024-01-08

* Added `sort_by_title` keyword option.


## 1.2.1 / 2023-06-17

* Updated dependencies.
* No longer explodes when a value for `order` is not provided in front matter.


## 1.2.0 / 2023-04-23

* Added optional `field` parameter.


## 1.1.1 / 2023-04-02

* Added [`attribution` support](https://github.com/mslinn/jekyll_plugin_support#subclass-attribution).


## 1.1.0 / 2023-03-14

* `outline_js` tag added, for including Javascript necessary to position images relating to the outline.
* Now generates a series of divs, instead of one big div.
* Now interprets numbers as decimal instead of octal.
* CSS documented and new `post_title` class defined.


## 1.0.2 / 2023-02-16

* Updated to `jekyll_plugin_support` v0.5.1


## 1.0.1 / 2023-02-14

* Now dependent upon `jekyll_plugin_support`


## 1.0.0 / 2022-04-02

* Initial version, this Jekyll plugin defines a block tag called `outline`.
