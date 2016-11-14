class ClientMailer < ApplicationMailer
  default from: "no-reply@springgh.com"
  
  def send_signup_alert(client)
  	@client = client
  	mail to: @client.email, subject: "Sign Up Alert"
  end
end
