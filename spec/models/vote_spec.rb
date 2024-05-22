require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe 'validations' do
    subject { build(:vote) }
    it { should validate_inclusion_of(:vote_type).in?(%w[upvote downvote]) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:video) }
  end
end
