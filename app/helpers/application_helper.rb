module ApplicationHelper
  def flash_class(level)
    case level.to_sym
      when :notice then "alert alert-info"
      when :success then "alert alert-success"
      when :error then "alert alert-danger"
      when :alert then "alert alert-danger"
    end
  end

  def active_class(link_path)
    current_page?(link_path) ? "active" : ""
  end

  def render_modal(title: "", body: "", footer: "")
    render(partial: '/partials/modal', locals: { title: title, body: body, footer: footer })
  end
end
