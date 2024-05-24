class VideoSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :url, :email, :vote

  def email
    object.user.email
  end

  def vote
    return nil unless instance_options[:current_user].present?
    
    user_vote = object.votes.detect { |vote| vote.user_id == instance_options[:current_user].id }
    user_vote ? user_vote.vote_type : nil
  end
end
