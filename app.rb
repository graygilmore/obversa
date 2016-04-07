require "sinatra"

module Obversa
  class Application < Sinatra::Base
    get "/" do
      erb :index
    end
  end
end
