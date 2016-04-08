require "sinatra/base"
require "faraday"
require "json"

module Obversa
  class Application < Sinatra::Base
    get "/" do
      response = api(:get) { |r| r.url "/api/products.json" }
      @products = JSON.parse(response.body)
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
