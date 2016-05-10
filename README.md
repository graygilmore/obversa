# obversa

Obversa is a front-end application for Solidus. The initial goal of this project is to expose weak or complicated endpoints in the Solidus API. Eventually this project will be used as a base for creating front-end applications that interact with Solidus.

## Authentication

Due to the nature of this app being separate from Solidus you will need to disable CSRF authentication in your app. In your application controller you need to change the value of `protect_from_forgery` from `:exception` to `:null_session`. You can also drop the `with:` altogether as `:null_session` is the default as of at least Rails 4.2.

Additionally, you will need to add a `skip_before_action` so that Devise also knows to skip CSRF verification.

```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  # Required for Devise to skip checking for the CSRF
  skip_before_action :verify_authenticity_token
end
```
