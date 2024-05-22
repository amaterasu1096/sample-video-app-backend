require 'rails_helper'

RSpec.describe Video, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:url) }
    it { should validate_uniqueness_of(:url) }
    it { should allow_value('https://www.youtube.com/watch?v=jNQXAC9IVRw').for(:url) }
    it { should_not allow_value('https://www.example.com').for(:url) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:votes) }
  end
end
