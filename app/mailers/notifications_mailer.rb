class NotificationsMailer < ActionMailer::Base

  default from: "no-reply@madebyjessa.com"
  default to: "butler.brian.c@gmail.com"

  def new_message(message)
    @message = message
    mail(subject: "Inquiry from " + message.name)
  end

end