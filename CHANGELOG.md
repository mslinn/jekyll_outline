# Change Log

## 1.3.1 / 2025-07-14

* Now warns of pages that do not have `order` defined in front matter.


## 1.3.0 / 2025-06-04

* Now relies on `jekyll_plugin_support` v3.1.0.
* Fixed missing </div>s.
* Reimplemented using nested classes, concluding with a call `to_s`
  instead of implementing crazy nesting tracking.
* The `fields` parameter was renamed to `pattern`, however for compatibility, both parameter names are accepted.
  If both are provided, `pattern` has priority.


## 1.2.6 / 2025-01-03

* Added `exclude_from_outline` optional front matter YAML element.
* Ignores all files named `index`, regardless of file type.


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
