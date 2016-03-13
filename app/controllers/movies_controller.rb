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
    
    @all_ratings = Movie.all_ratings
    
    unless params[:sort].nil?
      session[:sort] = params[:sort]
    end
    
    unless params[:ratings].nil?
      session[:ratings] = params[:ratings]
    end
    
    @movies = Movie.order(params[:sort])
    @sort = session[:sort]
    
    if session[:ratings] && session[:sort]
      @movies = Movie.order(@sort)
      @movies = @movies.select {|movie| session[:ratings].include? movie.rating}
      @movie_title = "hilite" if @sort == "title"
      @r_date = "hilite" if @sort == "release_date"
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