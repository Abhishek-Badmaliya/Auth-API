# frozen_string_literal: true

class Api::V1::PostsController < ApiController
  load_and_authorize_resource
  before_action :set_post, only: %i[show update destroy]

  def index
    @posts = Post.accessible_by(current_ability)
    # @posts = current_user.posts
    render json: @posts, status: :ok
  end

  def show
    render json: @post, status: :ok
  end

  def create
    @post = Post.new(post_params)
    #@post = current_user.posts.new(post_params)
    if @post.save
      render json: @post, status: :ok
    else
      render json: { data: @post.errors.full_messages, status: 'failed' }, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      render json: @post, status: :ok
    else
      render json: { data: @post.errors.full_messages, status: 'failed' }, status: :unprocessable_entity
    end
  end

  def destroy
    if @post.destroy
      render json: { data: 'Your post has been deleted successfully !', status: 'success' }, status: :ok
    else
      render json: { data: 'Oops, something went wrong !', status: 'failed' }
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
    #@post = current_user.posts.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: e.message, status: :unauthorized
  end

  def post_params
    params.require(:post).permit(:title, :body, :user_id)
  end
end
