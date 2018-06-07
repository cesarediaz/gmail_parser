require 'google/apis/gmail_v1'

class WelcomeController < ApplicationController
  def index
    gmail = Gmail.connect(:xoauth2, current_user.email, current_user.oauth_token)
    @search = 'paypal Recibo de su pago realizado'
    @emails = gmail.mailbox('Mis Mails').emails(gm: @search)

  end
end
