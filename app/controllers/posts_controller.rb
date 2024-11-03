class PostsController < ApplicationController
  before_action :set_post, only: [:show]

  def index
    @posts = Post.all.page(params[:page]).per(5)
    # @posts = Post.all.page(params[:page]).per(5)
  end

  # def show
  #   @posts = Post.all.page(params[:page])

  def show
    @post = Post.find(params[:id])

    @prev_post = Post.where('id < ?', @post.id).order(id: :desc).first
    @next_post = Post.where('id > ?', @post.id).order(id: :asc).first
  end
  # end

  private

  def set_post
    @post = Post.find(params[:id])
  end
end
