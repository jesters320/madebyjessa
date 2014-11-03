class MessageController < ApplicationController

  def create
    logger.debug params[:message]
	
	if !params[:message][:about].empty?
		@message = Message.new
		logger.debug "about wasn't empty"
		logger.debug "!" + params[:message][:about] + "!"
		logger.debug "empty: " + params[:message][:about].empty?.to_s
		flash[:error] = "sorry, something doesn't seem right."
		render "public/home" and return
	end
	
	params[:message].delete :about
	
	@message = Message.new(params[:message])
    	
	@message.set_products(params[:product_ids])
	
    if @message.valid?
      NotificationsMailer.new_message(@message).deliver
	  NotificationsMailer.thank_you_message(@message).deliver
      redirect_to(root_path, :notice => "Message was successfully sent.")
    else
	  flash[:error] = @message.errors.full_messages.join(" and ")
      render "public/home"
    end
  end
  
  private
  
	# Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:about, :name, :email, :additional_details, product_ids: [])
    end

end