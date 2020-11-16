require 'rails_helper'

RSpec.describe "Users", type: :system do
  describe 'ログイン前' do
    describe '新規登録機能' do
      let(:user) { build(:user) }
      before { visit sign_up_path }

      context 'フォームの入力値が正常な場合' do
        before do
          fill_in 'Email', with: user.email
          fill_in 'Password', with: user.password
          fill_in 'Password confirmation', with: user.password_confirmation
          click_button 'SignUp'
        end
        it "ユーザーの新規登録が成功する" do
          expect(current_path).to eq login_path
          expect(page).to have_selector '#notice', text: 'User was successfully created.'
        end
      end

      context 'メールアドレスが未入力の場合' do
        before do
          fill_in 'Email', with: ''
          fill_in 'Password', with: user.password
          fill_in 'Password confirmation', with: user.password_confirmation
          click_button 'SignUp'
        end
        it "ユーザーの新規登録が失敗する" do
          expect(current_path).to eq users_path
          expect(page).to have_selector '#error_explanation', text: "Email can't be blank"
        end
      end

      context '登録済みのメールアドレスを使用する場合' do
        let(:user) { create(:user) }
        before do
          fill_in 'Email', with: user.email
          fill_in 'Password', with: user.password
          fill_in 'Password confirmation', with: user.password_confirmation
          click_button 'SignUp'
        end
        it 'ユーザーの新規登録が失敗する' do
          expect(current_path).to eq users_path
          expect(page).to have_selector '#error_explanation', text: 'Email has already been taken'
        end
      end
    end

    describe 'マイページ' do
      context 'ログインしていない場合'
      it 'マイページへのアクセスが失敗する' do
        visit user_path(create(:user))
        expect(current_path).to eq login_path
        expect(page).to have_selector '#alert', text: 'Login required'
      end
    end
  end

  describe 'ログイン後' do
    let(:user) { create(:user) }
    before { log_in_as(user) }

    describe 'ユーザー編集' do
      before { visit edit_user_path(user) }
      context 'フォームの入力値が正常な場合' do
        before do
          fill_in 'Email', with: 'update@example.com'
          fill_in 'Password', with: 'update'
          fill_in 'Password confirmation', with: 'update'
          click_button 'Update'
        end
        it 'ユーザーの編集が成功する' do
          expect(current_path).to eq user_path(user)
          expect(page).to have_selector '#notice', text: 'User was successfully updated.'
        end
      end

      context 'メールアドレスが未入力の場合' do
        before do
          fill_in 'Email', with: ''
          fill_in 'Password', with: 'update'
          fill_in 'Password confirmation', with: 'update'
          click_button 'Update'
        end
        it 'ユーザーの編集が失敗する' do
          expect(current_path).to eq user_path(user)
          expect(page).to have_selector '#error_explanation', text: "Email can't be blank"
        end
      end

      context '登録済みのメールアドレスを使用した場合' do
        let(:another_user) { create(:user) }
        before do
          fill_in 'Email', with: another_user.email
          fill_in 'Password', with: 'update'
          fill_in 'Password confirmation', with: 'update'
          click_button 'Update'
        end
        it 'ユーザーの編集が失敗する' do
          expect(current_path).to eq user_path(user)
          expect(page).to have_selector '#error_explanation', text: 'Email has already been taken'
        end
      end

      context '他ユーザーの編集ページにアクセスした場合' do
        let(:another_user) { create(:user) }
        before { visit edit_user_path(another_user) }
        it '編集ページへのアクセスが失敗する' do
          expect(current_path).to eq user_path(user)
          expect(page).to have_selector '#alert', text: 'Forbidden access.'
        end
      end
    end
  end
end
