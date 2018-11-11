require 'product'

class PricingRule
  
  def initialize product: nil, rule: nil
    @product = product
    @rule = rule
  end
  
  def apply basket
    @items = basket.select { |product| product == @product }
    return 0 unless apply?

    @rule[:discount][Product.price(@product), @items.count]
  end
  
  def apply?
    @items.count >= @rule[:bought]
  end
  
end