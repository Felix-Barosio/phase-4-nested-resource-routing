class ReviewsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def index
    if params[:dog_house_id]
      dog_house = DogHouse.find(params[:dog_house_id])
      reviews = dog_house.reviews
    else
      reviews = Review.all
    end
    render json: reviews, except: [:created_at, :updated_at], include: {dog_house: {except: [:created_at, :updated_at]}}
  end

  def show
    review = Review.find(params[:id])
    render json:  review, except: [:created_at, :updated_at], include: {dog_house: {except: [:created_at, :updated_at]}}
  end

  def create
    review = Review.create(review_params)
    render json: review, status: :created
  end

  private

  def render_not_found_response
    render json: { error: "Review not found" }, status: :not_found
  end

  def review_params
    params.permit(:username, :comment, :rating)
  end

end
