module ApplicationHelper
  def controller?(*controller)
    controller.include?(params[:controller])
  end

  def action?(*action)
    action.include?(params[:action])
  end

  def players_number(min, max)
    return max unless min.present?
    min == max ? max : "#{min} - #{max}"
  end

  def min_age(age)
    age.to_s + "+" unless age.blank?
  end

  def beauty_date(date)
    l(date, format: "%H:%M %e-%m-%Y") if date
  end

  def location(city, province)
    "#{city} (#{province})" if city && province
  end

  def img_boardgame(boardgame, size = "thumbnail")
    if size == "thumbnail" && boardgame[:thumbnail].present?
      image_tag(boardgame[:thumbnail], class: "img-responsive thumb64", alt: boardgame[:name])
    elsif size == "image" && boardgame[:image].present?
      image_tag(boardgame[:image], class: "img-responsive", alt: boardgame[:name])
    end
  end
end
