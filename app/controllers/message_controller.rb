class MessageController < ApplicationController

  def create
    @message = Message.new(params[:message])
    
	logger.debug @message.name
	
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
      params.require(:message).permit(:name, :email, :additional_details, product_ids: [])
    end

end