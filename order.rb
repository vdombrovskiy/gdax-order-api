require 'coinbase/exchange'
require 'json'

class Order

  VALID_ACTIONS = %w(sell buy)
  VALID_CURRENCIES = %w(BTC USD ETH)

	attr_reader :base_currency, :quote_currency, :amount
  attr_accessor :orders
  
  def initialize(options)
    @base_currency = options[:base_currency]
    @quote_currency = options[:quote_currency]
    @amount = options[:amount].to_f
  end

  def self.create(options)
    action = options[:action]
    Object.const_get("#{action.capitalize}Order").new(options)
  end

  def client
  	@client ||= Coinbase::Exchange::Client.new('2uCwwiqMwT2sqscB',
  	 																					 'o8ICB58gZUJR6d9d7hu7sFTBeqHgg5VQ',
  	 																					 product_id: "#{base_currency}-#{quote_currency}")
  end

  def generate_json
    client.orderbook(level: 2) do |resp|
      self.orders = resp[order_key]
      if best_order
        return best_order
      else
        return average_order
      end
    end
  end

  def best_order
    best_order = orders.find{ |order| order[1].to_f == amount.to_f }
    if best_order
      {
        total: best_order[0].to_f * best_order[1].to_f,
        price: best_order[0],
        currency: quote_currency
      }.to_json
    end
  end

  def average_order
    suitable_orders = []
    remaining_amount = amount
    orders.each do |order|
      break if remaining_amount == 0
      order_amount = order[1].to_f
      if order_amount > remaining_amount
        price = (order[0].to_f / order_amount) * remaining_amount
        suitable_orders << [price, remaining_amount]
        remaining_amount = 0
      else
        suitable_orders << order
        remaining_amount -= order_amount
      end
    end
    average_price = suitable_orders.reduce(0){ |sum, order| sum + (order[0].to_f * order[1].to_f) } / amount
    {
      total: average_price * amount,
      price: average_price,
      currency: quote_currency
    }.to_json
  end
end

