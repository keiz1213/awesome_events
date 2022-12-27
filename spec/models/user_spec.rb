require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'FactoryBot' do
    it 'has a valid factory' do
      expect(FactoryBot.build(:user)).to be_valid
    end
  end

  describe '.find_or_create_from_auth_hash!' do
    let(:auth_hash) { {
      provider: 'github',
      uid: '1',
      info: {
        nickname: 'hoge',
        image: 'http://example.com/foo.jpg'
      }
    } }
    context 'when the user already exists' do
      it 'finds the user by auth_hash' do
        user = User.create(
          provider: 'github',
          uid: '1',
          name: 'hoge',
          image_url: 'http://example.com/foo.jpg'
        )
        expect(User.find_or_create_from_auth_hash!(auth_hash)).to eq user
      end
    end
    context 'when the user does not exist' do
      it 'create the user by auth_hash' do
        User.destroy_all
        user = User.find_or_create_from_auth_hash!(auth_hash)
        expect(user.uid).to eq auth_hash[:uid]
      end
    end
  end
end
