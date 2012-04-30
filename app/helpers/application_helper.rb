# encoding: utf-8
module ApplicationHelper

  # Returns the logo.
  def logo
    image_tag("logo.png", alt: "Logo")
  end

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = I18n.t('appname')
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  # Returns the a hash of supported locales.
  def supported_locales
    { "en"    => "English",
      "it"    => "Italiano",
      "zh-CN" => "中文" }
  end

  # Return the locale's flag.
  def flag(locale)
    image_tag("#{locale}.png", alt: locale)
  end

end
