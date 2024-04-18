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
    movie_id = params[:id]
    user_id = params[:user_id]
    movie_rented = Rental.where(movie_id: movie_id, user_id: user_id).first
    if movie_rented
      return render json: { error: "The movie is rented by the user"}, status: :unprocessable_entity
    end
    movie = Movie.find(movie_id)
    if movie.available_copies <= 0
      return render json: { error: "The movie '#{ movie.title }' is not available for rent"}, status: :unprocessable_entity
    end
    movie.available_copies -= 1
    user = User.find(user_id)
    movie.save
    user.rented << movie
    render json: movie
  end

end