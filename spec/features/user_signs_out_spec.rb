require 'rails_helper'

RSpec.feature 'User signs out' do
  scenario 'user signed in' do
    user = create :user

    sign_in user

    visit root_path

    click_link 'Sign Out'

    expect(page).to have_text 'You need to sign in or sign up before continuing.'
    expect(page).to have_no_link 'Sign Out'
    expect(page).to have_current_path new_user_session_path
  end
end
