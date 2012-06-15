# Mustache Rails

Implements Mustache views and templates for Rails 3.x

## Installation

``` ruby
gem 'mustache-rails', :require => 'mustache/railtie'
```

Or alternatively `require 'mustache/railtie'` in your `config/application.rb`.

## Usage

In typical mustache fashion, `.mustache` templates go under `app/templates` and view `.rb` files go under `app/views`. Any view classes will be looked for under the `::Views` modules.

Simple template scaffolding:

``` ruby
# app/views/layouts/application.rb
module Views
  module Layouts
    class Application < ActionView::Mustache
      def title
        "Hello"
      end
    end
  end
end
```

``` mustache
{{ ! app/templates/layouts/application.mustache }}
<!DOCTYPE html>
<html>
<head>
  <meta charset='utf-8'>
  <title>{{title}}</title>
</head>
<body>
  {{yield}}
</body>
</html>
```

``` ruby
# app/views/users/show.rb
module Views
  module Users
    class Show < Layouts::Application
      attr_reader :user
    end
  end
end
```

``` mustache
{{ ! app/templates/users/show.mustache }}
{{#user}}
  <h1>{{name}}</h1>
{{/user}}
```

### Optional Configuration

``` ruby
# config/application.rb
module Foo
  class Application < Rails::Application
    # Config defaults
    config.mustache.template_path = "app/templates"
    config.mustache.view_path = "app/views"
    config.mustache.view_namespace = "::Views"
  end
end
```

## License

Copyright &copy; 2012 Joshua Peek.

Released under the MIT license. See `LICENSE` for details.
