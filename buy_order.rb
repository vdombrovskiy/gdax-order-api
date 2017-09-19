require_relative 'order'

class BuyOrder < Order

  def order_key
    'asks'
  end
end