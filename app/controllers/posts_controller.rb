class PostsController < ApplicationController
  before_action :set_post, only: [:show]

  def index
    @posts = Post.all.page(params[:page])
    # @posts = Post.all.page(params[:page]).per(5)
  end

  def show
    @posts = Post.all.page(params[:page])
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end
end
