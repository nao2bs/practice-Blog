class CommentsController < ApplicationController
  before_action :set_post

  # def create
  #     @post.comments.create! comments_params
  #         # コメントが保存された後、通知を作成して保存する
  #         @notification = Notification.new(content: "New comment added!")
  #         @notification.comment = @comment
  #         @notification.save
  #     redirect_to @post
  # end

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)

    if @comment.save
      # コメントが保存された後、関連する通知を作成する
      @notification = @comment.notifications.build(content: 'New comment added!')
      @notification.save

      redirect_to @post, notice: 'Comment was successfully created.'
    else
      # コメントの保存に失敗した場合の処理
      flash.now[:alert] = 'Failed to create comment.'
      render 'posts/show'
    end
  end

  def destroy
    @post.comments.destroy params[:id]
    redirect_to @post
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
