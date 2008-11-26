# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def flash_messages
    [:error, :warning, :notice].collect do |which|
      capture_haml { haml_tag('div', flash[which], {:class => which.to_s}) }.strip if flash.include?(which)
    end.compact.join("\n")
  end

  def hidden
    {:style => 'display:none;'}
  end

  def hidden_if(condition)
    condition ? hidden : {}
  end

  def hidden_unless(condition)
    hidden_if(!condition)
  end
end
