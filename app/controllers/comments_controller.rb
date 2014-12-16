class CommentsController < ApplicationController

  before_action :set_comment, only: [:create, :destroy]
  # before_action :correct_user, only: [ :destroy]
  before_action :authenticate_user!,   only: [:create, :destroy]

  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.new(comment_params)
    @comment.user_id = current_user.id
    redirect_to article_path(@article)
    @comment = @article.save

  end

  def destroy
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
    @comment.destroy
    redirect_to article_path(@article)
  end

  private

    def set_comment
      @article = Article.find(params[:article_id])
    end

    # def correct_user
    #   @article = current_user.articles.find(params[:id])
    #   redirect_to articles_path if @article.nil?
    # end

    def comment_params
      params.require(:comment).permit(:commenter, :body)
    end

end
