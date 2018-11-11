require 'product'

class Checkout
  
  def initialize rules=[]
    @rules = rules
    @basket = []
  end
  
  def scan item
    @basket << item
  end
  
  def total
    (total_without_discount - discount).round(2)
  end
  
  def total_without_discount
    @basket.inject(0) { |sum, product| sum += Product.price(product) }
  end
  
  def discount
    @rules.inject(0) { |sum, rule| sum += rule.apply(@basket) }
  end
end