require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  describe 'ログイン前' do
    describe 'タスク新規作成ページ' do
      context 'ログインしていない場合' do
        before { visit new_task_path }
        it 'タスク新規作成ページへのアクセスが失敗する' do
          expect(current_path).to eq login_path
          expect(page).to have_selector '#alert', text: 'Login required'
        end
      end
    end

    describe 'タスク編集ページ' do
      let(:task) { create(:task) }
      context 'ログインしていない場合' do
        before { visit edit_task_path(task) }
        it 'タスク新規作成ページへのアクセスが失敗する' do
          expect(current_path).to eq login_path
          expect(page).to have_selector '#alert', text: 'Login required'
        end
      end
    end
  end

  describe 'ログイン後' do
    let(:task) { create(:task) }
    before { log_in_as(task.user) }

    describe 'タスク新規作成' do
      let(:new_task) { build(:task) }
      before { visit new_task_path }
      context '入力値が正常な場合' do
        before do
          fill_in 'Title', with: new_task.title
          fill_in 'Content', with: new_task.content
          select task.status, from: 'Status'
          fill_in 'Deadline', with: (Time.now + 1.day)
          click_button 'Create Task'
        end
        it 'タスクの新規作成が成功する' do
          expect(current_path).to eq task_path(Task.last)
          expect(page).to have_selector '#notice', text: 'Task was successfully created.'
          expect(page).to have_content new_task.title
        end
      end

      context 'タイトルが未入力の場合' do
        before do
          fill_in 'Title', with: ''
          fill_in 'Content', with: new_task.content
          select task.status, from: 'Status'
          fill_in 'Deadline', with: (Time.now + 1.day)
          click_button 'Create Task'
        end
        it 'タスクの新規作成に失敗する' do
          expect(current_path).to eq tasks_path
          expect(page).to have_selector '#error_explanation', text: "Title can't be blank"
          expect(visit tasks_path).to_not have_content new_task.content
        end
      end

      context '登録されているタイトルを使用する場合' do
        before do
          fill_in 'Title', with: task.title
          fill_in 'Content', with: new_task.content
          select task.status, from: 'Status'
          fill_in 'Deadline', with: (Time.now + 1.day)
          click_button 'Create Task'
        end
        it 'タスクの新規作成が失敗する' do
          expect(current_path).to eq tasks_path
          expect(page).to have_selector '#error_explanation', text: 'Title has already been taken'
          expect(visit tasks_path).to_not have_content new_task.content
        end
      end
    end

    describe 'タスク編集機能' do
      before { visit edit_task_path(task) }

      context '入力値が正常な場合' do
        before do
          fill_in 'Title', with: 'update'
          fill_in 'Content', with: 'update'
          select 'doing', from: 'Status'
          fill_in 'Deadline', with: (Time.now + 1.day)
          click_button 'Update Task'
        end
        it 'タスクの編集が成功する' do
          expect(current_path).to eq task_path(task)
          expect(page).to have_selector '#notice', text: 'Task was successfully updated.'
          expect(page).to have_content 'update'
        end
      end

      context 'タイトルが空白の場合' do
        before do
          fill_in 'Title', with: ''
          fill_in 'Content', with: 'update'
          select 'doing', from: 'Status'
          fill_in 'Deadline', with: (Time.now + 1.day)
          click_button 'Update Task'
        end
        it 'タイトルの編集が失敗する' do
          expect(current_path).to eq task_path(task)
          expect(page).to have_selector '#error_explanation', text: "Title can't be blank"
          expect(visit tasks_path).to_not have_content 'update'
        end
      end
    end

    describe 'タスク編集ページ' do
      let(:another_user) { create(:user) }
      before { log_in_as(another_user) }
      context '他ユーザーのタスク編集ページにアクセスする場合' do
        before { visit edit_task_path(task) }

        it 'タスク編集ページへのアクセスが失敗する' do
          expect(current_path).to eq root_path
          expect(page).to have_selector '#alert', text: 'Forbidden access.'
        end
      end
    end

    describe 'タスク削除' do
      before { log_in_as(task.user) }
      context 'Destroyリンクをクリックする場合' do
        before do
          page.accept_confirm do
            click_on 'Destroy'
          end
        end
        it 'タスクが削除される' do
          expect(current_path).to eq tasks_path
          expect(page).to have_selector '#notice', text: 'Task was successfully destroyed.'
          expect(page).to_not have_content task.title
        end
      end
    end
  end
end
