class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  def create
    @community = Community.find(params[:community_id])
    @message = Message.new(message_params)
    @message.community = @community
    @message.user = current_user
    if @message.save
      redirect_to community_path(@community)
    else
      raise
      render 'communities/show'
    end
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
