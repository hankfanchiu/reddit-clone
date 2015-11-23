module SubsHelper
  def display(sub)
    display = "<strong>#{h(sub.title)}</strong>"
    display += ": "
    display += display_descrip(sub.description) unless sub.description.empty?
    display.html_safe
  end

  def display_descrip(description)
    if description.length > 20
      h(description.slice(0, 20))
    else
      h(description)
    end
  end
end
