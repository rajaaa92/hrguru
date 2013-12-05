module ApplicationHelper

  def body_css_classes
    "#{controller_path.gsub('/', ' ')} #{action_name}"
  end
end
