# https://gist.github.com/henrik/2994129

require "support/i18n_helper"

describe "The base i18n files" do
  extend I18nHelper

  load_locales

  # Test for translation keys
  locales_to_keys.each do |locale, keys|
    unique_keys.each do |key|
      it "should translate '#{key}' in locale '#{locale}' since it's present in some other locale" do
        # Don't use "should include" or we get a ton of slow output.
        keys.include?(key).should be_true, "Expected '#{key}' to be among the '#{locale}' locale's translation keys, but it wasn't"
      end
    end
  end

  # Test for translated documents (conf/locales/documents/**.markdown)
  locales_to_documents.each do |locale, documents|
    unique_documents.each do |document|
      it "should translate document '#{document}' in locale '#{locale}' since it's present in some other locale" do
        documents.include?(document).should be_true, "Expected '#{document}' to be among the '#{locale}' locale's documents, but it wasn't"
      end
    end
  end
end
