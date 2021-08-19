require 'rails_helper'

describe 'タスク管理機能', type: :system do
  let(:user_a) { FactoryBot.create(:user, name: 'usera', email: 'a@example.com') }
  let(:user_b) { FactoryBot.create(:user, name: 'userb', email: 'b@example.com') }
  let!(:task_a) { FactoryBot.create(:task, name: 'first task', user: user_a) }

  before do
    # login user
    visit login_path
    fill_in 'メールアドレス', with: login_user.email
    fill_in 'パスワード', with: login_user.password
    click_button 'LOGIN'
  end

  shared_examples_for 'ユーザーAが作成したタスクが表示される' do
    it { expect(page). to have_content 'first task'}
  end


  describe '一覧表示機能' do
    context 'ユーザーAがログインしているとき' do
      let(:login_user) { user_a }

      # check user task list
      it_behaves_like 'ユーザーAが作成したタスクが表示される'
    end

    context 'ユーザーBがログインしているとき' do
      let(:login_user) { user_b }

      it 'ユーザーAのタスクが表示されないこと' do
      # not display usera task
        expect(page).to have_no_content 'first task'
      end
    end
  end

  describe '詳細表示機能' do
    context 'ユーザーAがログインしているとき' do
      let(:login_user) { user_a }

      before do
        visit task_path(task_a)
      end

      it_behaves_like 'ユーザーAが作成したタスクが表示される'
    end
  end

  describe '新規作成機能' do
    let(:login_user) { user_a }

    before do
      visit new_task_path
      fill_in 'タスク名', with: task_name
      click_button '登録する'
    end

    context '新規作成画面で名称を入力した時' do
      let(:task_name) { 'test task' }

      it '正常に登録される' do
        expect(page).to have_selector '.alert-success', text: 'test task'
      end
    end

    context '新規作成画面で名称を入力しなかったとき' do
      let(:task_name) { '' }

      it 'errorになる' do
        expect(page).to have_content 'タスク名を入力してください'
      end
    end
  end
end
