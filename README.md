# complate for Ruby

This is a Ruby on Rails and pure Ruby adapter for [complate](https://github.com/complate).
See https://github.com/complate/complate-sample-rails for example usage.

## Usage in Rails

First, add complate to your Gemfile:

```
gem "complate"
```

Now there are two options to call JSX/complate views from your controller:

1. A `render` based approach which adds jsx files from your views folder
   automatically and generates your complate bundle for you and
2. a custom approach to render views from precompiled complate bundles.

### Using `render`

In the `render` based approach complate-ruby manages your
bundles for you. It expects the `faucet-pipeline` and `complate-stream`
to be present in the `node_modules` directory of your app.
An minimal package.json for your app could look like:

```json
{
  "private": true,
  "dependencies": {
    "complate-stream": "^0.16.5",
    "faucet-pipeline-jsx": "^1.1.1"
  }
}
```

Now you can place views, layouts and partials ending with `.jsx`
in your Rails view directories.

Your view file must export a function returning a JSX-element.
A simple view could look like:

```jsx
import { createElement } from 'complate-stream';
export default ({ name }) => {
  return <span>Hello {name}!</span>;
};
```

Controller instance variables will be passed
into the parameters object of your exported function as seen
above. So a compoller action calling the view above could look like:

```ruby
class MyController < ApplicationController
  def greet
    @name = "World"
  end
end
```

#### Chunking / streaming

The Rails `render` method makes it hard to implement real chunking.
One reason is the layout/partial support it implements. This
adapter provides the `complate_stream` method to render a jsx/complate view
**witout** layout and partial support but **with** real streaming
instead.

```ruby
class MyController < ApplicationController
  include ActionController::Live
  def greet
    @name = "World"
    complate_stream
  end
end
```

### Using `complate` precompiled bundles

This approach assumes that there already is some kind of complate
bundle somewhere. This bundle should contain all your views
(registered with `complate.registerView`), your components and
complate-stream itself. The bundle should export an object
`complate` with values

* `render`: the `renderView` function bound to a renderer instance

    ```javascript
    renderer.renderView.bind(renderer)
    ```

* `safe`: complate's safe string function

You can call the following to render the "NameOfView" macro in
your controller actions with two parameters:

```ruby
complate("NameOfView", param1: "x", param2: "y")
```

This gem expect your bundle to be located in `dist/bundle.js`, but you can
reconfigure that with `config.complate.bundle_path = '...'`
or by using the option `:bundle_path` in the `complate` call:

```ruby
complate("MyView", foo: "bar", bundle_path: Rails.root.join('other_bundle.js'))
```

## Helpers

complate with Rails gives you access to rails helper methods. These are
accessible via the global variable `rails`.

```jsx
import { createElement } from 'complate-stream';
export default ({ name }) => {
  return <span><a href={rails.greet_url()}>Click me!</a></span>;
};
```

## HTML safe strings

complate will htmlencode all strings for you. It does **not** support
Rails HTML safe strings (`"foo".html_safe`) at the moment. So you'll
have to use complate's `safe` function to prevent complate from
escaping Strings.

The exception are helper calls. Here the usage of Rails HTML safe
Strings leads to automatically safe strings for complate too.
If you are using custom bundles you'll have to export complate's
`safe` function to
