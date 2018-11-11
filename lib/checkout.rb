class Checkout
  ARTICLES = { GR1: 3.11, SR1: 5, CF1: 11.23 }
  
  def initialize rules={}
    @rules = rules
    @basket = []
  end
  
  def scan item
    @basket << item
  end
  
  def total
    @basket.inject(0) { |sum, item| sum += ARTICLES[item]; sum }
  end
end