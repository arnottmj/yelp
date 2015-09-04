require 'rails_helper'

feature 'reviewing' do

  context 'when not logged in' do
    scenario 'a visitor cannot write a review' do
      Restaurant.create name: 'KFC'
      visit '/restaurants'
      click_link 'Review KFC'
      expect(page).to have_content 'Log in'
    end
  end

  context 'when logged in' do

    before do
      sign_up
      new_restaurant
      review_restaurant
    end

    scenario 'allows users to leave a review using a form' do
      expect(current_path).to eq '/restaurants'
      expect(page).to have_content('so so')
    end

    scenario 'users can only leave one review per restaurant' do
      review_restaurant
      expect(current_path).to eq '/restaurants'
      expect(page).to have_content('You have already reviewed this restaurant')
    end

    scenario 'allows a review to be deleted if it belongs to the user' do
      visit '/restaurants'
      click_link 'Delete review'
      expect(page).not_to have_content 'Delete Review'
      expect(page).to have_content 'Review deleted successfully'
    end

    def sign_up
      visit '/restaurants'
      click_link 'Sign up'
      fill_in 'Email', with: 'test@makers.com'
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '12345678'
      click_button 'Sign up'
    end

    def new_restaurant
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'delicious'
      click_button 'Create Restaurant'
    end

    def review_restaurant
      visit '/restaurants'
      click_link 'Review delicious'
      fill_in "Thoughts", with: "so so"
      select '3', from: 'Rating'
      click_button 'Leave Review'
    end
  end
end

# no test for 'doesnt allow a review to be deleted if it does not belong to the user' as it requires a whole new user to sign in
# havent done the test for 'not able to delete a review' when not logged in
