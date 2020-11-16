module UserSessionsHelper
  def log_in_as(user)
    visit login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'foobar'
    click_button 'Login'
  end
end

RSpec.configure do |config|
  config.include UserSessionsHelper, type: :system
end