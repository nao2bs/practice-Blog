class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show]

  def index
    @posts = Post.published.page(params[:page]).per(5)
    # @posts = Post.all.page(params[:page]).per(5)
  end

  # def show
  #   @posts = Post.all.page(params[:page])

  def show
    @post = Post.find(params[:id])

    # if @post.draft? && (!user_signed_in? || !current_user.admin?)
    #   redirect_to posts_path, alert: ''
    #   return
    # end

    redirect_to posts_path, alert: '記事が公開されていないかアクセス権がありません。' if @post.draft? && !current_user&.admin?

    @prev_post = Post.where('id < ?', @post.id).order(id: :desc).first
    @next_post = Post.where('id > ?', @post.id).order(id: :asc).first
  end
  # end

  private

  def set_post
    @post = Post.find(params[:id])
  end
end
