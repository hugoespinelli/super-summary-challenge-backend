class MoviesController < ApplicationController
  def index
    @movies = Movie.page(params[:page]).per(params[:per_page] || 10)
    render json: @movies
  end

  def recommendations
    favorite_movies = User.find(params[:user_id]).favorites.page(params[:page]).per(params[:per_page] || 10)
    @recommendations = RecommendationEngine.new(favorite_movies).recommendations
    render json: @recommendations
  end

  def user_rented_movies
    @rented = User.find(params[:user_id]).rented.page(params[:page]).per(params[:per_page] || 10)
    render json: @rented
  end

  def rent
    movie = Movie.find(params[:id])
    movie.available_copies -= 1
    user = User.find(params[:user_id])
    movie.save
    user.rented << movie
    render json: movie
    
  end
end