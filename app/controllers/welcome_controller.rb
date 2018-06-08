require 'google/apis/gmail_v1'

class WelcomeController < ApplicationController
  Gmail = Google::Apis::GmailV1

  def index
    @transactions = Transaction.all
  end

  def refresh_transactions
    Transaction.search_for_transactions(current_user)
    redirect_to root_path
  end
end
