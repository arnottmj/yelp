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
    end

    scenario 'allows users to leave a review using a form' do
      visit '/restaurants'
      click_link 'Review delicious'
      fill_in "Thoughts", with: "so so"
      select '3', from: 'Rating'
      click_button 'Leave Review'

      expect(current_path).to eq '/restaurants'
      expect(page).to have_content('so so')
    end

    scenario 'allows delete a review if it belongs to them' do
      visit '/restaurants'
      click_link 'Delete delicious'
      expect(page).not_to have_content 'delicious'
      expect(page).to have_content 'Restaurant deleted successfully'
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
  end
end
