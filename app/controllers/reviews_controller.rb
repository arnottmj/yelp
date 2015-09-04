class ReviewsController < ApplicationController

  before_action :authenticate_user!, :except => [:index, :show]

  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.new
  end

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = @restaurant.reviews.build(review_params.merge({user: current_user}))

    if @review.save
      redirect_to restaurants_path
    else
      if @review.errors[:user]
        flash[:notice] = 'You have already reviewed this restaurant'
        redirect_to restaurants_path
      else
        render :new
      end
    end
  end

  def destroy
    @review = Review.find(params[:id])
    if current_user.reviews.include?(@review)
      @review.destroy
      flash[:notice] = 'Review deleted successfully'
      redirect_to '/restaurants'
    else
      flash[:notice] = 'You did not add that review'
      redirect_to '/restaurants'
    end
  end

  def review_params
    params.require(:review).permit(:thoughts, :rating)
  end
end
