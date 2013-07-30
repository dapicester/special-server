# https://gist.github.com/henrik/2994129

require 'yaml'

module I18nHelper
  PLURALIZATION_KEYS = %w[
    zero
    one
    two
    few
    many
    other
  ]

  def load_locales
    base_i18n_files.each do |file|
      locale = File.basename(file, ".*")
      hash = YAML.load_file(file)[locale]
      add_keys locale, get_flat_keys(hash)
    end
  end

  def base_i18n_files
    Dir["config/locales/**/*.yml"].select do |file|
      File.basename(file).match I18n.available_locales.join('|')
    end
  end

  def locales_to_keys
    @locales_to_keys ||= {}
  end

  def locales_to_documents
    @locales_to_documents = locales_to_keys.keys.inject({}) do |hash, locale|
      # E.g. [ "terms" ]
      documents = Dir["config/locales/documents/*.#{locale}.*"].map { |file| File.basename(file, ".#{locale}.markdown") }
      hash.merge locale => documents
    end
  end

  def unique_keys
    locales_to_keys.values.flatten.uniq.sort
  end

  def unique_documents
    locales_to_documents.values.flatten.uniq.sort
  end

  def get_flat_keys(hash, path = [])
    hash.map do |k, v|
      new_path = path + [ k ]

      # Ignore any pluralization differences.
      if v.is_a?(Hash) && looks_like_plural?(v)
        v = "Pretend it's a leaf."
      end

      case v
      when Hash
        get_flat_keys(v, new_path)
      when String
        new_path.join(".")
      else
        raise "wtf? #{ v }"
      end
    end.flatten
  end

  def add_keys(locale, keys)
    if locales_to_keys.has_key? locale
      locales_to_keys[locale].push *keys
    else
      locales_to_keys[locale] = keys
    end
  end

  def looks_like_plural?(hash)
    hash.keys.length > 1 && hash.keys.all? { |k| PLURALIZATION_KEYS.include?(k) }
  end
end
