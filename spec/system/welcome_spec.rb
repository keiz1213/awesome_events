require 'rails_helper'

RSpec.describe "Welcome", type: :system do

  scenario "visit root_url" do
    visit root_path

    expect(page).to have_selector "h1", text: "イベント一覧"
  end

  scenario "display feature events,but not past events " do
    feature_event = FactoryBot.create(:event, start_at: Time.zone.now + 3.day)
    past_event = FactoryBot.create(:event, start_at: Time.zone.now + 1.day)

    travel_to Time.zone.now + 2.day do
      visit root_path
      expect(page).to have_selector "h5", text: feature_event.name
      expect(page).not_to have_selector "h5", text: past_event.name
    end
  end
end
