require 'rails_helper'

RSpec.describe "Events", type: :system do
  describe 'test3' do
    scenario 'destroy event', js: true do
      sign_in_as(FactoryBot.create(:user))
      event = FactoryBot.create(:event, owner: current_user)
      visit event_path(event)

      take_screenshot
      click_on 'イベントを削除する'

      expect {
        expect(page.accept_confirm).to eq '本当に削除しますか？'
        expect(page).to have_content '削除しました'
      }.to change(Event, :count).by(-1)
    end
  end

  describe 'test1' do
    context 'when login is not requred' do
      scenario 'visit event detail' do
        event = FactoryBot.create(:event)
        visit event_path(event)

        expect(page).to have_selector 'h1', text: event.name
      end
    end
  end
  describe 'test2' do
    context 'when login is required' do
      scenario 'visit new event form' do
        sign_in_as(FactoryBot.create(:user))
        visit new_event_path
        expect(page).to have_selector 'h1', text: 'イベント作成'
      end

      scenario 'create event' do
        sign_in_as(FactoryBot.create(:user))
        visit new_event_path
        expect(page).to have_selector 'h1', text: 'イベント作成'
      
        fill_in '名前', with: "TokyoRubyKaigi"
        fill_in '場所', with: '東京'
        fill_in '内容', with: 'tokyo.rbによる地域Ruby会議'
      
        start_at = Time.current
        end_at = start_at + 3.hour
      
        start_at_field = 'event_start_at'
        select start_at.strftime('%Y'), from: "#{start_at_field}_1i"
        select I18n.l(start_at, format: '%B'), from: "#{start_at_field}_2i"
        select start_at.strftime('%-d'), from: "#{start_at_field}_3i"
        select start_at.strftime('%H'), from: "#{start_at_field}_4i"
        select start_at.strftime('%M'), from: "#{start_at_field}_5i"
      
        end_at_field = 'event_end_at'
        select end_at.strftime('%Y'), from: "#{end_at_field}_1i"
        select I18n.l(end_at, format: '%B'), from: "#{end_at_field}_2i"
        select end_at.strftime('%-d'), from: "#{end_at_field}_3i"
        select end_at.strftime('%H'), from: "#{end_at_field}_4i"
        select end_at.strftime('%M'), from: "#{end_at_field}_5i"
      
        click_on '登録する'
      
        expect(page).to have_content '作成しました'
        expect(page).to have_content 'TokyoRubyKaigi'
        expect(page).to have_content current_user.name
      end
    end
  end
end
