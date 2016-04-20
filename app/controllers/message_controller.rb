# require 'mandrill'
require 'openssl'

class MessageController < ApplicationController

  def create
    logger.info params[:message]
	@today = Time.now
	
	if check_for_bot
		@message = Message.new
		render "public/home" and return
	end
	
	@message = Message.new(params[:message])
    	
	#@message.set_products(params[:product_ids])
	
    if @message.valid?
	  begin
		# old mailer logic
		#NotificationsMailer.test_message.deliver
		
		#NotificationsMailer.thank_you_message(@message).deliver
		
		# logic to send mail through transactional email client
		#send_through_mandrill
		send_through_sendgrid
		
		redirect_to(root_path, :notice => "Message was successfully sent.")
	  rescue Exception => exc
	     logger.error ("Error in creating messages:: #{exc.message}")
	     flash[:error] = "sorry, something doesn't seem right."
		 render "public/home" and return
	  end

    else
	  flash[:error] = @message.errors.full_messages.join(" and ")
      render "public/home"
    end
  end
  
  private
  
	def check_for_bot
		logger.info "check for bot"
		bot = false
		
		logger.info "check honeypot"
		# check for form fillers with honeypot
		if !params[:message][:about].empty?
			bot = true
			bot_detected("about wasn't empty", params[:message][:about])
		end
		
		logger.info "check quick bot"
		logger.info "Submission time - " + (Time.now - Time.parse(params[:message][:now])).to_s
		# check for playback bots with date
		if params[:message][:now].empty? || Time.now - Time.parse(params[:message][:now]) <= 10
			bot = true
			bot_detected("now seemed off", params[:message][:now])
		end
		
		params[:message].delete :about
		params[:message].delete :now
		
		bot
	end
	
	def bot_detected(error_message, error_value)
		logger.info error_message
		logger.info "!" + error_value + "!"
		flash[:error] = MBJConstants::MISC_ERROR
	end
  
	# Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:now, :about)
    end
	
	def send_through_mandrill
		logger.info "inside send_through_mandrill"
	
		m = Mandrill::API.new
		mandrill_inquiry_message = {  
		 :subject=> "Inquiry from " + @message.name,  
		 :from_name=> "made by jessa",  
		 :text=>"here is the info...",  
		 :to=>[  
		   {  
			 :email=> ENV['email_to'],  
			 :name=> "the boss"  
		   }  
		 ],  
		 :html=>@message.inquiry_html,  
		 :from_email=>ENV['email_username'] 
		}  
		sending = m.messages.send mandrill_inquiry_message
		
		logger.info "inquiry response"
		logger.info sending
		
		mandrill_thank_you_message = {  
		 :subject=> "Thanks for inquiring!!!",  
		 :from_name=> "made by jessa",   
		 :to=>[  
		   {  
			 :email=> @message.email,  
			 :name=> @message.name  
		   }  
		 ],  
		 :html=>@message.thank_you_html,  
		 :from_email=>ENV['email_username'] 
		}  
		sending = m.messages.send mandrill_thank_you_message
		
		logger.info "thank you response"
		logger.info sending
		
	end
	
	def send_through_sendgrid
		logger.info "inside send_through_sendgrid"
	
		client = SendGrid::Client.new(api_key: ENV['SENDGRID_APIKEY'])
		
		sendgrid_inquiry_message = SendGrid::Mail.new do |m|
		  m.to = ENV['email_to']
		  m.to_name = "the boss"
		  m.from = ENV['email_username']
		  m.from_name = "made by jessa"
		  m.subject = "Inquiry from " + @message.name
		  m.html = @message.inquiry_html
		end
		
		logger.info "sending inquiry"
		inquiry_response = client.send(sendgrid_inquiry_message)
		
		logger.info "inquiry response"
		logger.info inquiry_response.code
		logger.info inquiry_response.body

		sendgrid_thank_you_message = SendGrid::Mail.new do |m|
		  m.to = @message.email
		  m.to_name = @message.name
		  m.from = ENV['email_username']
		  m.from_name = "made by jessa"
		  m.subject = "Thanks for inquiring!!!"
		  m.html = @message.thank_you_html
		end
		
		logger.info "sending thank you"
		thank_you_response = client.send(sendgrid_thank_you_message)
		
		logger.info "thank you response"
		logger.info thank_you_response.code
		logger.info thank_you_response.body
		
	end

end