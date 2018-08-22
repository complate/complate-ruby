# complate for Ruby

## Rails

First, add complate to your Gemfile:

```
gem "complate"
```

To render the NameOfView macro in your actions with two parameters:

```ruby
complate("NameOfView", param_1: "x", param_2: "y")
```

This gem expect your bundle to be located in `dist/bundle.js`, but you can
reconfigure that with:

```ruby
config.complate.bundle_path = Rails.root.join("bundle.js")
```

See https://github.com/complate/complate-ruby/tree/master/test/js how a very
simple complate/faucet setup for your project might look like.
