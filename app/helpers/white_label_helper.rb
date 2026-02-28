module WhiteLabelHelper
  def clinic_name
    Current.clinic&.name || "ClinicCRM"
  end

  def clinic_primary_color
    Current.clinic&.primary_color || "#4F46E5"
  end

  def clinic_secondary_color
    Current.clinic&.secondary_color || "#818CF8"
  end

  def white_label_css_variables
    primary = clinic_primary_color
    safe_tag(
      "<style>:root { --clinic-primary: #{primary}; --clinic-primary-light: #{lighten(primary)}; --clinic-primary-dark: #{darken(primary)}; }</style>"
    )
  end

  def clinic_logo_or_default
    if Current.clinic&.logo&.attached?
      image_tag Current.clinic.logo, alt: clinic_name, class: "h-8 w-8 rounded-lg object-cover"
    else
      content_tag(:div, clinic_name[0..1].upcase, class: "h-8 w-8 rounded-lg bg-primary text-white flex items-center justify-center text-xs font-bold")
    end
  end

  private

  def lighten(hex)
    adjust_color(hex, 40)
  end

  def darken(hex)
    adjust_color(hex, -40)
  end

  def adjust_color(hex, amount)
    hex = hex.delete("#")
    r = [[hex[0..1].to_i(16) + amount, 0].max, 255].min
    g = [[hex[2..3].to_i(16) + amount, 0].max, 255].min
    b = [[hex[4..5].to_i(16) + amount, 0].max, 255].min
    "#%02x%02x%02x" % [r, g, b]
  end

  def safe_tag(html)
    html.html_safe
  end
end
