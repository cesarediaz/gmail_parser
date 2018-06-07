require 'google/apis/gmail_v1'

class WelcomeController < ApplicationController
  def index
    begin
      gmail = Gmail.connect(:xoauth2, current_user.email, current_user.oauth_token)
      @search = 'paypal Recibo de su pago realizado'
      emails = gmail.inbox.emails(gm: @search)

      @paypal_transactions = []
      emails.each do |email|
        @paypal_transactions <<  GmailScrapper.paypal(email.body)
      end
      @paypal_transactions.reverse!

    rescue Exception => e
      @error = 'An error with gmail connection happened. Re login again please'
      @paypal_transactions = []
    end
  end
end
