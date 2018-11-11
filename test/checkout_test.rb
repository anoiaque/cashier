$:.unshift File.join(File.dirname(__FILE__),'..','lib')
require 'minitest/autorun'
require 'checkout'
require 'pricing_rule'

class CheckoutTest < Minitest::Test
  RULES = [
    PricingRule.new(product: :GR1, rule: { bought: 1, discount: ->(price, count) { (count / 2) * price}}),
    PricingRule.new(product: :SR1, rule: { bought: 3, discount: ->(price, count) { 0.50 * count }}),
    PricingRule.new(product: :CF1, rule: { bought: 3, discount: ->(price, count) {(1 - (2.0/ 3.0))*price * count }}),
  ]
  
  def test_articles_sequence_checkout_without_pricing_rules
    checkout = Checkout.new
    [:GR1, :SR1, :GR1, :GR1, :CF1].each { |item| checkout.scan(item)}
    
    assert_equal 3.11 + 5 + 3.11 + 3.11 + 11.23, checkout.total
  end
  
  def test_articles_sequence_checkout_with_three_green_tea
    checkout = Checkout.new(RULES)
    
    [:GR1, :SR1, :GR1, :GR1, :CF1].each { |item| checkout.scan(item)}
    
    assert_equal 22.45, checkout.total
  end
  
  def test_articles_sequence_checkout_with_two_green_tea_only
    checkout = Checkout.new(RULES)
    
    [:GR1, :GR1].each { |item| checkout.scan(item)}
    
    assert_equal 3.11, checkout.total
  end
  
  def test_articles_sequence_checkout_with_three_strawberries
    checkout = Checkout.new(RULES)
  
    [:SR1, :SR1, :GR1, :SR1].each { |item| checkout.scan(item)}
  
    assert_equal 16.61, checkout.total
  end
  
  def test_articles_sequence_checkout_with_10_strawberries
    checkout = Checkout.new(RULES)
    items = [:SR1, :SR1, :GR1, :SR1, :CF1, :SR1, :SR1, :SR1, :SR1, :SR1, :SR1, :SR1]
    
    items.each { |item| checkout.scan(item)}
  
    assert_equal 10*4.5 + 3.11 + 11.23 , checkout.total
  end

  def test_articles_sequence_checkout_with_three_coffees
    checkout = Checkout.new(RULES)
  
    [:GR1, :CF1, :SR1, :CF1, :CF1].each { |item| checkout.scan(item)}
  
    assert_equal 30.57, checkout.total
  end

  def test_articles_sequence_checkout_with_7_coffees
    checkout = Checkout.new(RULES)
  
    [:CF1, :GR1, :CF1, :CF1, :SR1, :CF1, :CF1, :CF1, :CF1].each { |item| checkout.scan(item)}
  
    assert_equal (7*(11.23 * 2.0/3) + 3.11 + 5.0).round(2) , checkout.total
  end
  
  #extra rules
  
  def test_articles_sequence_checkout_with_rule_buy_2_get_1_free
    rule = PricingRule.new(product: :GR1, rule: { bought: 2, discount: ->(price, count) { (count / 3) * price}})
    checkout = Checkout.new([rule])
    
    [:GR1, :GR1, :GR1, :GR1, :GR1, :GR1].each { |item| checkout.scan(item)}
  
    assert_equal 2*(2*3.11) , checkout.total
  end
  
  def test_articles_sequence_checkout_with_rule_more_than_5_bought_3_first_half_price
    rule = PricingRule.new(product: :CF1, rule: { bought: 5, discount: ->(price, count) { 3 * (price / 2.0)}})
    
    checkout = Checkout.new([rule])
  
    [:CF1, :CF1, :CF1, :CF1, :CF1, :CF1].each { |item| checkout.scan(item)}
  
    assert_equal ((11.23 / 2.0)*3 + 3* 11.23).round(2) , checkout.total
  end
  
end