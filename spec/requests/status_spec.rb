require 'rails_helper'

RSpec.describe "Status", type: :request do
  describe "GET /status" do
    it 'returns json' do
      get "/status"
      expect(response.content_type).to include "application/json"
    end
  end
end
