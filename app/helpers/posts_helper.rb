module PostsHelper
  def top_level_comments
    @post.comments.where(parent_comment_id: nil)
  end
end
