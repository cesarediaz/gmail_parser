class TransactionsService
  include GmailScrapper
  
  SELLERS = { paypal: { filter_email_phrase: 'paypal Recibo de su pago realizado' } }

  def initialize(current_user)
    @current_user = current_user
  end

  def call
    save_transactions(filter_emails)
  rescue Google::Apis::AuthorizationError
    false
  end
  
  private

  def filter_emails
    filter_date = @current_user.transactions.last&.created_at || Date.today - 10.years
    emails = []

    SELLERS.each do |seller, search|
      emails = paypal(search[:filter_email_phrase], filter_date) if seller == :paypal
    end

    emails
  end

  def paypal(phrase, filter_date)
    service = GmailService.new(@current_user).call()
    emails = list_user_messages(service, phrase, filter_date)

    transactions = []
    emails.messages&.each do |email|
      message = get_user_message(service, email)
      transactions <<  GmailScrapper.paypal(message)
    end
    transactions.reverse!
  end

  def list_user_messages(service, phrase, filter_date)
    service.list_user_messages( 
      'me',
      max_results: 100,
      q: "#{phrase} after: #{Date.parse(filter_date.strftime('%d-%b-%Y'))}"
    )
  end

  def get_user_message(service, email)
    service.get_user_message('me', email.id).payload.body.data
  end

  def save_transactions(transactions)
    return [] if transactions.empty?
    transactions.each do |company, date, description, price, quantity, import|
      description = 'Not available' if description.empty?
      Transaction.create(company: company,
                          date: date.to_datetime,
                          description: description,
                          price: price,
                          quantity: quantity,
                          import: import,
                          user_id: @current_user.id
                          )
    end
  end
end
