require 'product'

class PricingRule
  
  def initialize product: nil, rule: nil
    @product = product
    @rule = rule
  end
  
  def apply items
    send(@rule, items)
  end
  
  private
  
  def buy_one_get_one_free items
    count = items.count { |item| item == @product }
    
    (count / 2) * Product.price(@product)
  end
end