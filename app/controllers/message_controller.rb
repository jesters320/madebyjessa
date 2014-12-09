require 'mandrill'

class MessageController < ApplicationController

  def create
    logger.info params[:message]
	@today = Date.today
	
	if check_for_bot
		@message = Message.new
		render "public/home" and return
	end
	
	@message = Message.new(params[:message])
    	
	#@message.set_products(params[:product_ids])
	
    if @message.valid?
	  begin
		# old mailer logic
		#NotificationsMailer.new_message(@message).deliver
		#NotificationsMailer.thank_you_message(@message).deliver
		
		# mandrill logic to send mail
		send_through_mandrill
		
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
		bot = false
		
		# check for form fillers with honeypot
		if !params[:message][:about].empty?
			bot = true
			bot_detected("about wasn't empty", params[:message][:about])
		end
		
		# check for playback bots with date
		if params[:message][:now].empty? || params[:message][:now].to_date < (Date.today - 2.days)
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

end