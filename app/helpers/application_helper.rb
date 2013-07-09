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

  # Returns the locale's flag.
  def flag(locale)
    image_tag("#{locale}.png", alt: locale)
  end

  # Returns the link to MailCatcher
  def mailcatcher_web
    link_to 'MailCatcher', 'http://localhost:1080', target: '_blank'
  end

end
