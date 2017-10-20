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
