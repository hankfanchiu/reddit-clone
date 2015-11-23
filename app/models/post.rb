# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  url        :string
#  content    :text
#  author_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Post < ActiveRecord::Base
  validates :author_id, :title, :subs, presence: true

  belongs_to :author, class_name: "User", foreign_key: :author_id

  has_many :post_subs, dependent: :destroy, inverse_of: :post
  has_many :subs, through: :post_subs
  has_many :comments, dependent: :destroy

  def comments_by_parent_id
    comments_by_parent_id = Hash.new { |h, k| h[k] = [] }

    comments.includes(:author).each do |comment|
      comments_by_parent_id[comment.parent_comment_id] << comment
    end

    comments_by_parent_id
  end
end
