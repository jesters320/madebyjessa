class PublicController < ApplicationController
  def home
	@message = Message.new
	@today = Time.now
  end
end
