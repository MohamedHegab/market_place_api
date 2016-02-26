require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
	before(:each) { request.headers['Accept'] = "application/vnd.marketplace.v1" }

  describe "GET #show" do
    before(:each) do
      @user = FactoryGirl.create :user
      get :show, id: @user.id, format: :json
    end

    it "returns the information about a reporter on a hash" do
      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(user_response[:email]).to eql @user.email
    end

    it { should respond_with 200 }
  end

  describe "POST #create" do
    context "when is succefully created" do
      before(:each) do
        @user_attributes = FactoryGirl.attributes_for :user
        post :create, { user: @user_attributes }, format: :json
      end

      it "renders the json representation for the user record just created" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eql @user_attributes[:email]
      end

      it { should respond_with 201 }
    end

    context "when is not created" do
      before(:each) do
        @invalid_user_attributes = FactoryGirl.attributes_for(:user, email: nil)
        post :create, { user: @invalid_user_attributes }, format: :json
      end

      it "renders an errors json" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:errors)
      end

      it "renders the json errors on why the user could not be created" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:errors][:email]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end

  describe "POST #update" do
    before(:each) do 
      @user = FactoryGirl.create(:user)
    end
    context "when is updated" do
      before(:each) do
        @valid_user_attributes = FactoryGirl.attributes_for(:user)
        put :update, { id: @user.id , user: @valid_user_attributes }, format: :json
      end

      it "renders the Json record of the user currently updated" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eql @valid_user_attributes[:email]
      end

      it { should respond_with 200 }
    end

    context "when is not updated" do 
      before(:each) do
        @invalid_user_attributes = FactoryGirl.attributes_for(:user, email: nil)
        put :update, { id: @user.id, user: @invalid_user_attributes}, format: :json
      end

      it "renders the Json errors on why the user couldn't be updated" do 
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:errors][:email]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end
end
