class PostsController < ApplicationController
  before_action :require_login!, except: :show
  before_action :require_author, only: [:edit, :update, :destroy]

  def new
    @post = Post.new
    render :new
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      redirect_to post_url(@post)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
    render :edit
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_url(@post)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :edit
    end
  end

  def show
    @post = Post.find(params[:id])
    @comments_by_parent_id = @post.comments_by_parent_id
    render :show
  end

  def destroy
    @post = Post.destroy(params[:id])
    redirect_to subs_url
  end

  def upvote
    vote(1)
    redirect_to :back
  end

  def downvote
    vote(-1)
    redirect_to :back
  end

  private

  def require_author
    authored_post = current_user.posts.find(params[:id])
    redirect_to post_url(params[:id]) unless authored_post
  end

  def post_params
    params.require(:post).permit(:title, :url, :content, sub_ids: [])
  end
end
