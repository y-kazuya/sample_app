class LikesController < ApplicationController

  def index
    @last_like_id = Like.last.id
    respond_to do |format|
      format.html
      format.json { render json: @last_like_id }
    end
  end
  def create
    @like = Like.new(micropost_id: like_params, user_id: current_user.id)
    @like.save
    respond_to do |format|
      format.html
      format.json { render json: @like }
    end
  end

  def destroy
    like = Like.find(params[:id])
    like.destroy
    respond_to do |format|
      format.html
      format.json
    end

  end

  private

  def like_params
    params.permit(:micropost_id).require(:micropost_id)
  end
end
