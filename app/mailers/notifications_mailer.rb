class NotificationsMailer < ActionMailer::Base

  default from: ENV['email_username']

  def new_message(message)
    @message = message
    mail(to: ENV['email_to'], subject: "Inquiry from " + message.name)
  end
  
  def thank_you_message(message)
	@message = message
	mail(to: @message.email, subject: 'Thanks for inquiring!!!')
  end
end