class ArticlesController < ApplicationController

  before_action :set_article, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :authenticate_user!,   except: [:index, :show]

  def new
    @article = current_user.articles.build
  end

  def create
    @article = current_user.articles.build(article_params)
    @article.user_id = current_user.id

    @article.save
    render 'create'

  end

  def show
    @article = Article.find(params[:id])
  end

  def index
    @articles = Article.all.order("created_at DESC")
    @last = Article.order("created_at DESC").limit(5)
    @commented = Article.joins(:comments).group(:article_id).order('count_all desc').limit(2).count
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])

    if @article.update(article_params)
      redirect_to @article
    else
      render 'edit'
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    @article.user_id = current_user.id

    redirect_to articles_path
  end



  private

    def set_article
      @article = Article.find(params[:id])
    end

    def correct_user
      @article = current_user.articles.find(params[:id])
      redirect_to articles_path if @article.nil?
    end

    def article_params
      params.require(:article).permit(:title, :text)
    end

end

