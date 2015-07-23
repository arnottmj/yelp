require 'rails_helper'

feature 'reviewing' do
  before do
    sign_up
    Restaurant.create name: 'KFC'
  end

  scenario 'allows users to leave a review using a form' do
     visit '/restaurants'
     click_link 'Review KFC'
     fill_in "Thoughts", with: "so so"
     select '3', from: 'Rating'
     click_button 'Leave Review'

     expect(current_path).to eq '/restaurants'
     expect(page).to have_content('so so')
  end

  scenario 'allows delete a review if it belongs to them' do
    visit '/restaurants'
    click_link 'Delete KFC'
    expect(page).not_to have_content 'KFC'
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
end