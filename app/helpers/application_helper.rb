module ApplicationHelper
  def author?(post)
    current_user == post.author
  end

  def moderator?(sub)
    current_user == sub.moderator
  end

  def authenticity
    html = <<-HTML
      <input type="hidden"
        name="authenticity_token"
        value="#{form_authenticity_token}">
    HTML
    html.html_safe
  end

  def up_arrow
    "&uarr;".html_safe
  end

  def down_arrow
    "&darr;".html_safe
  end

  def upvote(object)
    if object.class.name == "Post"
      action = upvote_post_url(object)
    elsif object.class.name == "Comment"
      action = upvote_comment_url(object)
    end

    link_to up_arrow, action, method: :post
  end

  def downvote(object)
    if object.class.name == "Post"
      action = downvote_post_url(object)
    elsif object.class.name == "Comment"
      action = downvote_comment_url(object)
    end

    link_to down_arrow, action, method: :post
  end

  def vote_count(object)
    type, id = object.class.name, object.id
    Vote.where(votable_type: type, votable_id: id).sum(:value)
  end

  def voting(object)
    "#{upvote(object)} #{downvote(object)} (#{vote_count(object)})".html_safe
  end
end
