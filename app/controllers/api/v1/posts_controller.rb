# frozen_string_literal: true

class Api::V1::PostsController < ApiController
  load_and_authorize_resource
  before_action :set_post, only: %i[show update destroy]

  def index
    @posts = Post.accessible_by(current_ability)
    # @posts = current_user.posts
    if @posts.present?
      render json: @posts, status: 200
    else
      render json: { error: 'No posts' }, status: 404
    end
  end

  def show
    render json: @post, status: 200
  end

  def search
    @parameter = params[:title]
    @post = Post.where('lower(title) LIKE :title', title: "%#{@parameter}%")
    if @post != []
      render json: @post
    else
      render json: 'Oops, there were not any similar matches !', status: 404
    end
  end

  def create
    @post = Post.new(post_params)
    # @post = current_user.posts.new(post_params)
    if @post.save
      render json: @post, status: 201
    else
      render json: { error: 'Something went Wrong !' }, status: 422
    end
  end

  def update
    @post.update(post_params)
    render json: @post, status: 200
  end

  def destroy
    @post.destroy
    render json: { data: 'Your post has been deleted successfully !' }, status: 200
  end

  private

  def set_post
    @post = Post.find(params[:id])
    # @post = current_user.posts.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: e.message, status: 401
  end

  def post_params
    params.require(:post).permit(:title, :body, :user_id)
  end
end
