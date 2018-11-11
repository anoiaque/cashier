class Product
  PRICES = { GR1: 3.11, SR1: 5, CF1: 11.23 }
  
  def self.price code
    PRICES[code]
  end
end