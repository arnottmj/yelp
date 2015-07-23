class ReviewsController < ApplicationController

  before_action :authenticate_user!, :except => [:index, :show]

  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.new
  end

  def create
    # @restaurant = Restaurant.find(params[:restaurant_id])
    # @restaurant.reviews.create(review_params)
    # redirect_to restaurants_path
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.new(review_params)

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

  def review_params
    params[:review][:user_id] = current_user.id
    params[:review][:restaurant_id] = params[:restaurant_id]
    params.require(:review).permit(:thoughts, :rating, :user_id, :restaurant_id)
  end
end
