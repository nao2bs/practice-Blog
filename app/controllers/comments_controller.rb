class CommentsController < ApplicationController
  before_action :set_post

  #   def create
  #     @post.comments.create! comments_params
  #     @comment = @post.comments.build(comments_params)
  #     respond_to do |format|
  #       if @comment.save
  #         format.turbo_stream
  #         format.html { redirect_to @post, notice: 'コメントを投稿しました！' }
  #         else
  #         format.html { redirect_to @post, alert: 'コメントの投稿に失敗しました。' }
  #         end
  #       end
  #     end
  #     # redirect_to @post
  #   end

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comments_params)

    respond_to do |format|
      if @comment.save
        format.turbo_stream
        format.html { redirect_to @post, notice: 'コメントを投稿しました！' }
      else
        format.html { redirect_to @post, alert: '投稿に失敗しました。' }
      end
    end # respond_to の end
  end # create の end

  # def create
  #     @post = Post.find(params[:post_id])
  #     @comment = @post.comments.build(comment_params)
  #     if @comment.save
  #         redirect_to @post, notice: 'コメントを投稿しました！'
  #     else
  #         redirect_to @post, alert: 'コメントの投稿に失敗しました。'
  #     end
  # end
  def destroy
    @post.comments.destroy params[:id]
    redirect_to @post
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comments_params
    params.required(:comment).permit(:content)
  end
end
