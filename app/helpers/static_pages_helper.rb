require 'faker'

module StaticPagesHelper

  # Generate random content.
  def fake_paragraph
    Faker::Lorem.paragraphs.join ' '
  end

end
