class MoviesController < ApplicationController
  
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  

  def index
    @movies = Movie.all
    
    if not params[:sort].nil?
      @movies = Movie.order(params[:sort])
    end
    
    @all_ratings =  Movie.get_ratings
    @selected_ratings = @all_ratings
  
    ratings_hash = params[:ratings]
    if not ratings_hash.nil?
      @selected_ratings = ratings_hash.keys
      unselected_movies = Movie.all - Movie.where(rating: @selected_ratings)
      @movies = @movies - unselected_movies
    end
    
    if params[:sort] == 'title'
      @titleclicked = 'hilite'
    elsif params[:sort] == 'release_date'
      @dateclicked = 'hilite'
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
