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

  def min_age(age)
    age.to_s+"+"
  end

  def beauty_date(date)
    l(date, format: "%H:%M %e-%m-%Y") if date
  end

  def location(city, province)
    "#{city} (#{province})" if city && province
  end
end
