require 'spec_helper'

describe Review do
  it { should belong_to(:restaurant) }
end

# the above uses the gem shoulda. 

describe Review, :type => :model do
  it "is invalid if the rating is more than 5" do
    review = Review.new(rating: 10)
    expect(review).to have(1).error_on(:rating)
  end
end