class PublicController < ApplicationController
  def home
	@message = Message.new
  end
end
