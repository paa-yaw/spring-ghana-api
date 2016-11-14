require "rails_helper"

RSpec.describe ClientMailer, type: :mailer do
  include Rails.application.routes.url_helpers

  before do 
  	@client = FactoryGirl.create :client
  	# @email  = ClientMailer.create_signup(@client.email, @client.first_name)
  	@client_mailer = ClientMailer.send_signup_alert(@client)
  end

  it "should be delivered to the client's email" do 
  	expect(@client_mailer).to deliver_to(@client.email)
  end

  it "should be sent from no-reply@springgh.com" do 
  	expect(@client_mailer).to deliver_from("no-reply@springgh.com")
  end

  it "should contain client's message in email body" do 
  	expect(@client_mailer).to have_body_text(/#{@client.first_name}/)
  end

  it "should have subject" do 
  	expect(@client_mailer).to have_subject(/Sign Up Alert/)
  end
end
