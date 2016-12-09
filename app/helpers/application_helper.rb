module ApplicationHelper
  def controller?(*controller)
    controller.include?(params[:controller])
  end

  def action?(*action)
    action.include?(params[:action])
  end

  def players_number(min, max)
    (min == max) ? min : "#{min} - #{max}"
  end
end
