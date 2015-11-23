class Vote < ActiveRecord::Base
  validates :user_id, presence: true
  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }

  belongs_to :votable, polymorphic: true

  belongs_to :voter, inverse_of: :votes
    class_name: "User",
    foreign_key: :voter_id
end
