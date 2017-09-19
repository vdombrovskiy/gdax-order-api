require 'sinatra/base'
require 'sinatra/param'
require_relative 'order'
require_relative 'sell_order'
require_relative 'buy_order'

class Server < Sinatra::Base
  helpers Sinatra::Param

  before do
    content_type :json
  end

  post '/' do
    body_params = JSON.parse(request.body.read)
    params.merge!(body_params)
    param :action, String, required: true, in: Order::VALID_ACTIONS
    param :base_currency, String, required: true, in: Order::VALID_CURRENCIES
    param :quote_currency, String, required: true, in: Order::VALID_CURRENCIES

    Order.create(params).generate_json
  end
end

run Server.run!
