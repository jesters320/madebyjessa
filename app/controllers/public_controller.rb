class PublicController < ApplicationController
  def home
	@message = Message.new
	@today = Date.today
  end
end
