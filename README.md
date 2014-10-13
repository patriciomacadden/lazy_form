# LazyForm

Forms for the rest of us, the lazy.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lazy_form'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install lazy_form
```

## Usage

It's quite simple. See an example:

```html
<%# views/_form.erb %>
<% form_for User.new, '/users' do |f| %>
  <p>
    <%= f.label :username, 'Username' %>
    <%= f.text :username %>
  </p>
  <p>
    <%= f.label :password, 'Password' %>
    <%= f.password :password %>
  </p>
  <p>
    <%= f.label :admin, 'Admin?' %>
    <%= f.checkbox :admin %>
  </p>
<% end %>
```

### Example using [Cuba](https://github.com/soveran/cuba)

```ruby
require 'cuba'
require 'cuba/render'
require 'lazy_form'

Cuba.plugin Cuba::Render
Cuba.plugin LazyForm::Helper

Cuba.define do
  on root do
    partial '_form'
  end
end
```

### Example using [Hobbit](https://github.com/patriciomacadden/hobbit)

```ruby
require 'hobbit'
require 'hobbit/render'
require 'lazy_form'

class App < Hobbit::Base
  include LazyForm::Helper

  get '/' do
    partial 'form'
  end
end
```

### Example using [Sinatra](https://github.com/sinatra/sinatra)

```ruby
require 'sinatra/base'
require 'lazy_form/sinatra'

class App < Sinatra::Base
  include LazyForm::Helper

  get '/' do
    partial :'form', layout: false
  end
end
```

## What else can I do with this gem?

Please see the `LazyForm::Builder` class in order to see available methods. I'm
too lazy to write the docs!

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

See the [LICENSE](https://github.com/patriciomacadden/lazy_form/blob/master/LICENSE).
