require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'FactoryBot' do
    it "generates associated data from a factory" do
      event = FactoryBot.create(:event)
      puts "This event's user is #{event.owner.inspect}"
    end
  end


  describe 'validation' do
    it "is invalid without a name" do
      event = FactoryBot.build(:event, name: nil)
      event.valid?
      expect(event.errors[:name]).to include("を入力してください")
    end

    it "is invalid without a place" do
      event = FactoryBot.build(:event, place: nil)
      event.valid?
      expect(event.errors[:place]).to include("を入力してください")
    end

    it "is invalid without a content" do
      event = FactoryBot.build(:event, content: nil)
      event.valid?
      expect(event.errors[:content]).to include("を入力してください")
    end

    it "is invalid without a start_at" do
      event = FactoryBot.build(:event, start_at: nil)
      event.valid?
      expect(event.errors[:start_at]).to include("を入力してください")
    end

    it "is invalid without a end_at" do
      event = FactoryBot.build(:event, end_at: nil)
      event.valid?
      expect(event.errors[:end_at]).to include("を入力してください")
    end

    it "is invalid with a name exceeding 50 characters" do
      characters = "a" * 51
      event = FactoryBot.build(:event, name: characters)
      event.valid?
      expect(event.errors[:name]).to include("は50文字以内で入力してください")
    end

    it "is invalid with a place exceeding 100 characters" do
      characters = "a" * 101
      event = FactoryBot.build(:event, place: characters)
      event.valid?
      expect(event.errors[:place]).to include("は100文字以内で入力してください")
    end

    it "is invalid with a content exceeding 2000 characters" do
      characters = "a" * 2001
      event = FactoryBot.build(:event, content: characters)
      event.valid?
      expect(event.errors[:content]).to include("は2000文字以内で入力してください")
    end
  end

  describe '#created_by?' do
    it "returns true if the user passed the argument created the event" do
      user = User.create(
        provider: "github",
        uid: 1,
        name: "test",
        image_url: "http://test.com/test.jpg"
      )

      event = user.created_events.create(
        owner_id: user,
        name: "test",
        place: "test",
        start_at: Time.zone.now + 1.hours,
        end_at: Time.zone.now + 2.hours
      )

      expect(event.created_by?(user)).to be true
    end
  end
end
