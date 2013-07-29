Tire.configure do
  logger Rails.root + "log/tire_#{Rails.env}.log"
  url ENV['BONSAI_URL'] if Rails.env.production?
end

Tire::Model::Search.index_prefix [
  Rails.application.class.parent_name.downcase,
  Rails.env.to_s.downcase
].join('_')
