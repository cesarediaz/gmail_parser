require 'test_helper'

class GmailScrapperTest < Minitest::Test
  def test_seller_name
    assert_equal ['Udemy', '04 Jun 2018 13:14:03', 'Dissecting Ruby on Rails 5 - Become a Professional Developer', '$10,99 USD', '1', '$10,99 USD'], 
    GmailScrapper::Paypal.call(open(Rails.root + 'test/modules/email.html'))
  end   
end
