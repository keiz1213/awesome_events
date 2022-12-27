require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  describe '#new' do
    context "as an authenticated user" do
      before do
        @user = FactoryBot.create(:user)
      end

      it 'responds successfully' do
        sign_in(@user)
        get :new
        expect(response).to be_successful
      end
    end

    context "as a guest" do
      it 'returns a 302 response' do
        get :new
        expect(response).to have_http_status "302"
      end

      it 'redirects to the root_page' do
        get :new
        expect(response).to redirect_to "/"
      end
    end
  end

  describe '#create' do
    context 'as an authenticated user' do
      before do
        @user = FactoryBot.create(:user)
      end

      context 'with valid attributes' do
        it 'adds a event' do
          sign_in(@user)
          event_params = FactoryBot.attributes_for(:event)
          expect {
            post :create, params: { event: event_params }
          }.to change(@user.created_events, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'does not add a event' do
          event_params = FactoryBot.attributes_for(:event, :invalid)
          sign_in(@user)
          expect {
            post :create, format: :js, params: { event: event_params }
          }.to_not change(@user.created_events, :count)
        end
      end
    end

    context 'as a guest' do
      it "returns a 302 response" do
        event_params = FactoryBot.attributes_for(:event)
        post :create, params: { event: event_params }
        expect(response).to have_http_status "302"
      end

      it "redirects to the root_page" do
        event_params = FactoryBot.attributes_for(:event)
        post :create, params: { event: event_params }
        expect(response).to redirect_to "/"
      end
    end
  end

  describe '#update' do
    context 'as an authorized user' do
      before do
        @user = FactoryBot.create(:user)
        @event = FactoryBot.create(:event, owner: @user)
      end

      it "updates a event" do
        event_params = FactoryBot.attributes_for(:event, name: "new event name")
        sign_in(@user)
        patch :update, params: { id: @event.id, event: event_params }
        expect(@event.reload.name).to eq "new event name"
      end
    end

    # context 'as an unauthorized user' do
    #   before do
    #     @user = FactoryBot.create(:user)
    #     other_user = FactoryBot.create(:user)
    #     @event = FactoryBot.create(:event, owner: other_user, name: "Same Old Name")
    #   end

    #   it "does not update the event" do
    #     event_params = FactoryBot.attributes_for(:event, name: "New Name")
    #     sign_in(@user)
    #     patch :update, params: { id: @event.id, event: event_params }
    #     expect(@event.reload.name).to eq "Same Old Name"
    #   end
    # end
  end

  describe '#destroy' do
    context "as an authorized user" do
      before do
        @user = FactoryBot.create(:user)
        @event = FactoryBot.create(:event, owner: @user)
      end

      it "deletes a project" do
        sign_in(@user)
        expect {
          delete :destroy, params: { id: @event.id }
        }.to change(@user.created_events, :count).by(-1)
      end
    end
  end

  private

  def sign_in(user)
    session[:user_id] = user.id
  end
end
