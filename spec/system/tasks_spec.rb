require 'rails_helper'

describe 'タスク管理機能', type: :system do
  describe '一覧表示機能' do
    before do
      # create user
      user_a = FactoryBot.create(:user, name: 'usera', email: 'a@example.com')
      # create task the user has
      FactoryBot.create(:task, name: 'first task', user: user_a)
    end

    context 'ユーザーがログインしているとき' do
      before do
        # login user
        visit login_path
        fill_in 'メールアドレス', with: 'a@example.com'
        fill_in 'パスワード', with: 'testuser'
        click_button 'LOGIN'
      end

      it 'ユーザーが作成したタスクが表示される' do
        # check user task list
        expect(page).to have_content 'first task'
      end
    end
  end
end
