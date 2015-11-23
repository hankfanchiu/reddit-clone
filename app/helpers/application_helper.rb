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

  def upvote(object)
    if object.class.name == "Post"
      action = upvote_post_url(object)
    elsif object.class.name == "Comment"
      action = upvote_comment_url(object)
    end

    link_to("&#9650;".html_safe, action, method: :post )
  end

  def downvote(object)
    if object.class.name == "Post"
      action = downvote_post_url(object)
    elsif object.class.name == "Comment"
      action = downvote_comment_url(object)
    end

    link_to("&#9660;".html_safe, action, method: :post)
  end

  def vote_count(object)
    type, id = object.class.name, object.id
    votes = Vote.where(votable_type: type, votable_id: id)
    votes.sum(:value)
  end

  def voting(object)
    html = "#{upvote(object)} #{vote_count(object)} #{downvote(object)}"
    html.html_safe
  end

  def bootstrap_class_for flash_type
    case flash_type
      when :success
        "alert-success"
      when :error
        "alert-error"
      when :alert
        "alert-block"
      when :notice
        "alert-info"
      else
        flash_type.to_s
    end
  end
end
