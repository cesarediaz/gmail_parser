require 'google/apis/gmail_v1'

class GmailService
  Gmail = Google::Apis::GmailV1
  def initialize(current_user)
    @current_user = current_user
  end

  def call
    init_gmail_service
  rescue Google::Apis::AuthorizationError
    false
  end

  private

  def init_gmail_service
    client = Signet::OAuth2::Client.new(access_token: @current_user.oauth_token)
    client.expires_in = 1.week.from_now
    service = Gmail::GmailService.new
    service.authorization = client
    service
  end

end
