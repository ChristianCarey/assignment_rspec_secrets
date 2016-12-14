require 'rails_helper'

describe SecretsController do
  let(:secret) { create(:secret) }
  let(:user) { secret.author }

  before do
    session[:user_id] = user.id
  end

  describe "POST #create" do 
    
    context "valid input" do 
      it "creates a secret" do
        expect {
          process :create, params: { secret: attributes_for(:secret) }
        }.to change(Secret, :count).by(1)
      end

      it "redirects to new secret's page" do
        process :create, params: { secret: attributes_for(:secret) }
        expect(response).to redirect_to(secret_path(Secret.last.id))
      end
    end

    context "invalid input" do
      it "rejects creation" do
        expect {
          process :create, params: { secret: attributes_for(:secret, title: 'a') }
        }.to change(Secret, :count).by(0)
      end

      it "doesn't redirect to new secret's page" do
        process :create, params: { secret: attributes_for(:secret, title: 'a') }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "DELETE #destroy" do

    before { secret }

    context "valid user's secret" do
      it "can be destroyed" do
        expect {
          process :destroy, params: { id: secret.id }
        }.to change(Secret, :count).by(-1)
      end
    end

    context "not user's secret" do
      let(:new_user) { create(:user) }

      before do
        user
        session[:user_id] = new_user.id
      end

      it "can't be destroyed" do
        expect {
          process :destroy, params: { id: secret.id }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
