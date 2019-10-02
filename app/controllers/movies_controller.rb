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
    @category = nil
    @ratings = nil
    
    newPage = false
    #we have parameters for category already present
    if params[:category]
    	@category = params[:category]
    	session[:category] = @category
    #no parameters present check if anything in session to carry over
    elsif session[:category]
    	@category = session[:category]
    	newPage = true
    else
	    @category = params[:category] || @category
    end
    
    #same process as above but for ratings
    if params[:ratings]
    	@ratings = params[:ratings]
    	session[:ratings] = @ratings
	elsif session[:ratings]
		@ratings = session[:ratings]
		newPage = true
	else    
	    @ratings = params[:ratings] || Hash[ @all_ratings.map {|ratings| [ratings, 1]} ]
    end

	if newPage
		flash.keep
		redirect_to movies_path({:ratings=>@ratings, :category => @category})
	end
	
    #query only ratings checkboxed and order based on category chosen
    @movies = Movie.where("rating in (?)", @ratings.keys).order(@category)
    #@movies = Movie.order(@category)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
