require 'rails_helper'

RSpec.describe "UserSessions", type: :system do
  let(:user) { create(:user) }

  describe 'ログイン前' do
    before { visit login_path }

    context 'フォームの入力値が正常な場合' do
      before do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: 'foobar'
        click_button 'Login'
      end
      it 'ログイン処理が成功する' do
        expect(current_path).to eq root_path
        expect(page).to have_selector '#notice', text: 'Login successful'
      end
    end

    context 'フォームが未入力の場合' do
      before do
        fill_in 'Email', with: ''
        fill_in 'Password', with: ''
        click_button 'Login'
      end
      it 'ログイン処理が失敗する' do
        expect(current_path).to eq login_path
        expect(page).to have_selector '#alert', text: 'Login failed'
      end
    end
  end

  describe 'ログイン後' do
    before { log_in_as(user) }

    context 'ログアウトボタンをクリック' do
      before { click_link 'Logout' }
      it 'ログアウト処理が成功する' do
        expect(current_path).to eq root_path
        expect(page).to have_selector '#notice', text: 'Logged out'
      end
    end
  end
end
