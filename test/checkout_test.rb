$:.unshift File.join(File.dirname(__FILE__),'..','lib')
require 'minitest/autorun'
require 'checkout'

class CheckoutTest < Minitest::Test
  
  def test_articles_sequence_checkout_without_special_rules
    checkout = Checkout.new
    [:GR1, :SR1, :GR1, :GR1, :CF1].each { |item| checkout.scan(item)}
    
    assert_equal (3.11 + 5 + 3.11 + 3.11 + 11.23), checkout.total
  end
end