# complate for Ruby

## Rails

First, add complate to your Gemfile:

```
gem "complate"
```

Add this to your `ApplicationController`:

```ruby
include Complate::Rails::ActionControllerExtensions
```

To render something in your actions:

```ruby
complate(signature, to, be, determined)
```

This gem expect your bundle to be located in /dist/bundle.js. See 
https://github.com/complate/complate-ruby/tree/master/test/js how a
very simple complate/faucet setup for your project might look like.

