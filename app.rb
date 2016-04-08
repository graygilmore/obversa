require "sinatra/base"

module Obversa
  class Application < Sinatra::Base
    get "/" do
      erb :index
    end
  end
end
