class ReviewsController < ApplicationController

  before_action :authenticate_user!, :except => [:index, :show]
  
  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.new
  end

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @restaurant.reviews.create(review_params)
    redirect_to restaurants_path
  end

  def review_params
    params[:review][:user_id] = current_user.id
    params.require(:review).permit(:thoughts, :rating, :user_id)
  end
end