class ArticlesController < ApplicationController
# http_basic_authenticate_with name: "dhh", password: "secret", except: [:index, :show]

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
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

    redirect_to articles_path
  end

  private
    def article_params
      params.require(:article).permit(:title, :text)
    end

end

