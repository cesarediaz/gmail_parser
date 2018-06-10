require 'rails_helper'

describe WelcomeController do
  describe "#refresh_transactions" do
    context "getting transactions succesfull" do
      before do
        allow(TransactionsService).to receive_message_chain(:new, :call).and_return(true)
      end

      it "returns a correct status code" do
        get :refresh_transactions
        expect(response.status).to eq 302
      end
    end

    context "getting transactions failure" do
      before do
        allow(TransactionsService).to receive_message_chain(:new, :call).and_return(false)
      end

      it "returns a correct status code" do
        get :refresh_transactions
        expect(response.status).to eq 302
        expect(flash[:alert]).to match(/You need to sign in or sign up before continuing.*/)
      end
    end
  end
end
