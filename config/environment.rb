# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
SpecialServer::Application.initialize!

# Set global default page size
WillPaginate.per_page = 10
