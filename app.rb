require "sinatra/base"
require "faraday"

module Obversa
  class Application < Sinatra::Base
    get "/" do
      erb :index
    end

    private

    def api(method, &block)
      conn.send(method) do |r|
        if method == :post
          r.headers["Content-Type"] = "application/json"
        end
        block.call(r)
      end
    end

    def conn
      Faraday.new(url: "#{api_url}")
    end

    def api_url
      ENV["API_HOST"] || "http://localhost:9494"
    end
  end
end
