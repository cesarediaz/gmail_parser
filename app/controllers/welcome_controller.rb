class WelcomeController < ApplicationController
  def index
    @transactions = Transaction.all
  end

  def refresh_transactions
    if TransactionsService.new(current_user).call()
      redirect_to root_path, notice: 'Refresh done!'
    else
      redirect_to destroy_user_session_path
    end
  end
end
