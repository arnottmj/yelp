require 'rails_helper'

feature 'restaurants' do
  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end

  context 'restaurants have been added' do
    before do
      Restaurant.create(name:'KFC')
    end

    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

  context 'viewing restaurants' do

    let!(:kfc){Restaurant.create(name:'KFC')}

    scenario 'lets a user view a restaurant' do
      visit '/restaurants'
      click_link 'KFC'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq "/restaurants/#{kfc.id}"
    end
  end

  context 'when not logged in' do

    before {Restaurant.create name: 'KFC'}

    scenario 'a visitor cannot add a restaurant' do
      visit '/restaurants'
      click_link 'Add a restaurant'
      expect(page).to have_content 'Log in'
    end

    scenario 'a visitor cannot edit a restaurant' do
      visit '/restaurants'
      click_link 'Edit KFC'
      expect(page).to have_content 'Log in'
    end

    scenario 'a visitor cannot delete a restaurant' do
      visit '/restaurants'
      click_link 'Delete KFC'
      expect(page).to have_content 'Log in'
    end
  end

  context 'when logged in' do
    before do
      sign_up
      new_restaurant
    end

    context 'creating restaurants' do
      scenario 'prompts user to fill out a form, then displays the new restaurant' do
        visit '/restaurants'
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'KFC'
        click_button 'Create Restaurant'
        expect(page).to have_content 'KFC'
        expect(current_path).to eq '/restaurants'
      end

      context 'an invalid restaurant' do
        it 'does not let you submit a name that is too short' do
          visit '/restaurants'
          click_link 'Add a restaurant'
          fill_in 'Name', with: 'kf'
          click_button 'Create Restaurant'
          expect(page).not_to have_css 'h2', text: 'kf'
          expect(page).to have_content 'error'
        end
      end
    end


    context 'editing restaurants' do

      scenario 'lets a user edit their own restaurants' do
        visit '/restaurants'
        click_link 'Edit delicious'
        fill_in 'Name', with: 'more delicious'
        click_button 'Update Restaurant'
        expect(page).to have_content 'more delicious'
        expect(current_path).to eq '/restaurants'
      end

      scenario 'stops a user editing other peoples restaurants' do
        Restaurant.create name: 'Restaurant with no ID'
        visit '/restaurants'
        click_link 'Edit Restaurant with no ID'
        expect(page).to have_content 'You did not add that restaurant'
        expect(current_path).to eq '/restaurants'
      end
    end

    context 'deleting restaurants' do

      scenario 'lets a user delete their own restaurants' do
        visit '/restaurants'
        click_link 'Delete delicious'
        expect(page).not_to have_content 'delicious'
        expect(page).to have_content 'Restaurant deleted successfully'
      end

      scenario 'stops a user deleting other peoples restaurants' do
        Restaurant.create name: 'Restaurant with no ID'
        visit '/restaurants'
        click_link 'Delete Restaurant with no ID'
        expect(page).to have_content 'You did not add that restaurant'
      end
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
