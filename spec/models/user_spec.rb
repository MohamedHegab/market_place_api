require 'rails_helper'

RSpec.describe User do
  before { @user = FactoryGirl.build(:user) }

  subject { @user }

  it { expect(@user).to respond_to(:email) }
  it { expect(@user).to respond_to(:password) }
  it { expect(@user).to respond_to(:password_confirmation)}

  it { expect(@user).to be_valid }

  it { expect(@user).to validate_presence_of(:email) }
  it { expect(@user).to validate_uniqueness_of(:email) }
	it { expect(@user).to validate_confirmation_of(:password) }
	it { expect(@user).to allow_value('example@domain.com').for(:email) }
end
