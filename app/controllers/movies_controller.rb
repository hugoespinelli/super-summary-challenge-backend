class MoviesController < ApplicationController

  def index
    @movies = apply_pagination(Movie)
    render json: @movies
  end

  def recommendations
    favorite_movies = User.find(params[:user_id]).favorites
    @recommendations = RecommendationEngine.new(favorite_movies).recommendations
    render json: @recommendations
  end

  def user_rented_movies
    @rented = apply_pagination(User.find(params[:user_id]).rented)
    render json: @rented
  end

  def rent
    movie = Movie.find(params[:id])
    unless movie.available_copies >= 1
      render json: { error: "The movie '#{ movie.title }' is not available for rent"}
    else
      movie.available_copies -= 1
      user = User.find(params[:user_id])
      movie.save
      user.rented << movie
      render json: movie
    end
    
  end

end