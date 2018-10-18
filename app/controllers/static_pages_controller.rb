class StaticPagesController < ApplicationController
  require 'will_paginate/array'
  def home
    if logged_in?
      @micropost  = current_user.microposts.build
      set_feed_items
    end
  end

  def help
  end

  def about
  end

  def contact
  end

  private

  def set_feed_items
    case params[:sort]
    when "iine" then
      @feed_items = []
      likes = current_user.likes
      likes.each do |like|
        @feed_items << Micropost.find(like.micropost_id)
      end
      @feed_items = @feed_items.sort {|a, b| b <=> a }.paginate(page: params[:page])
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

end