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

  def vote_count(object)
    type, id = object.class.name, object.id
    Vote.where(votable_type: type, votable_id: id).sum(:value)
  end
end
