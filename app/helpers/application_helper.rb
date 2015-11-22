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
end
