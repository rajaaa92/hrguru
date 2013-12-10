module ApplicationHelper

  def menu_class(name)
    'active' if name == controller_name
  end

  def body_css_classes
    "#{controller_path.gsub('/', ' ')} #{action_name}"
  end

  def backbone_view
    [controller_name, action_name].map(&:camelcase).join
  end

  def bootstrap_flash
    flash_msg = ""
    flash.each do |name, msg|
      flash_msg << "
        <div class='alert alert-#{get_alert_class name} alert-dismissable'>
          <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button>
          #{msg}
        </div>" if msg.is_a? String
    end
    raw flash_msg
  end

  private

  def get_alert_class(type)
    case type
    when :alert
      "warning"
    when :error
      "danger"
    else
      "success"
    end
  end
end
