require_relative 'order'

class SellOrder < Order

  def order_key
    'bids'
  end
end