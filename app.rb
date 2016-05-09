require "sinatra/base"
require "sinatra/reloader"
require "faraday"
require "json"

module Obversa
  class Application < Sinatra::Base
    configure :development do
      register Sinatra::Reloader
    end

    get "/" do
      redirect "/products"
    end

    get "/products" do
      response = api(:get) { |r| r.url "/api/products.json" }
      @products = JSON.parse(response.body)["products"]
      erb :"products/index"
    end

    # Main categories
    get "/category/:slug" do |slug|
      taxon_response = api(:get) { |r| r.url "api/taxonomies/#{slug}.json" }
      @taxon = JSON.parse(taxon_response.body)
      products_response = api(:get) { |r| r.url "/api/taxons/products.json?id=#{slug}" }
      @products = JSON.parse(products_response.body)["products"]
      erb :category
    end

    get "/products/:slug" do |slug|
      response = api(:get) { |r| r.url "/api/products/#{slug}.json" }
      @product = JSON.parse(response.body)
      erb :"products/show"
    end

    post "/line-items" do
      response = api(:post) do |r|
        order_id = "12345"
        variant = "line_item[variant_id]=#{params['variant']}"
        quantity = "line_item[quantity]=#{params['quantity']}"
        r.url "/api/orders/#{order_id}/line_items?#{variant}&#{quantity}"
      end

      if response.status == 201
        redirect "/cart"
      else
        redirect back
      end
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
