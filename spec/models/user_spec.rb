require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
  end

  describe 'associations' do
    it { should have_many(:votes) }
    it { should have_many(:videos) }
  end

  describe "uniqueness" do
    subject { build(:user) }
    it { should validate_uniqueness_of(:email) }
  end
end
