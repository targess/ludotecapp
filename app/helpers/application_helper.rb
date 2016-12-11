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

  def img_boardgame(boardgame, size = "thumbnail" )
    if size == "thumbnail"
      image_tag(boardgame[:thumbnail], class: "img-responsive thumb64", alt: boardgame[:name])
    elsif size == "image"
      image_tag(boardgame[:image], class: "img-responsive", alt: boardgame[:name])
    end
  end
end
