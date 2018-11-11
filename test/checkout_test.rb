$:.unshift File.join(File.dirname(__FILE__),'..','lib')
require 'minitest/autorun'
require 'checkout'
require 'pricing_rule'

class CheckoutTest < Minitest::Test
  RULES = [
    PricingRule.new(product: :GR1, rule: :buy_one_get_one_free),
  ]
  
  def test_articles_sequence_checkout_without_pricing_special_rules
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
  
end