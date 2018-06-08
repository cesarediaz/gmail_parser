require 'google/apis/gmail_v1'

class Transaction < ApplicationRecord
  Gmail = Google::Apis::GmailV1

  belongs_to :user

  validates :description, :company, :price, :date, presence: :true
  validates :description, uniqueness: { scope: :date, message: "should be just once" }

  SELLERS = { paypal: { filter_email_phrase: 'paypal Recibo de su pago realizado' } }

  def self.search_for_transactions(current_user)
    transactions = []
    transactions  = filter_emails( current_user)

    save_transactions(transactions, current_user) if transactions.count > 0
  rescue Exception => e
    error = 'An error with gmail connection happened. Re login again please'
    transactions = []
  end
  
  private

  def self.filter_emails( current_user)
    filter_date = current_user&.transactions.count > 0 ? current_user.transactions.last.created_at : Date.today - 10.years

    emails = []
    SELLERS.each do |seller, search|
      emails = paypal(current_user, search[:filter_email_phrase], filter_date) if seller == :paypal
    end
    emails
  end

  def self.paypal(current_user, phrase, filter_date)
    client = Signet::OAuth2::Client.new(access_token: current_user.oauth_token)
    client.expires_in = 1.week.from_now
    service = Gmail::GmailService.new
    service.authorization = client
    
    emails = service.list_user_messages(
      'me',
      max_results: 100,
      q: "#{phrase} after: #{Date.parse(filter_date.strftime('%d-%b-%Y'))}"
     )

    transactions = []
    emails.messages.each do |email|
      message = service.get_user_message('me', email.id).payload.body.data

      transactions <<  GmailScrapper.paypal(message)
    end
    transactions.reverse!
  end

  def self.save_transactions(transactions, current_user)
    return if transactions.empty?
    transactions.each do |company, date, description, price, quantity, import|
      description = 'Not available' if description.empty?
      Transaction.create(company: company,
                          date: date.to_datetime,
                          description: description,
                          price: price,
                          quantity: quantity,
                          import: import,
                          user_id: current_user.id
                          )
    end
  end
end
