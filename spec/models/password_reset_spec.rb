require 'spec_helper'

describe PasswordReset do
  it_behaves_like 'ActiveModel'

  before do
    @password_reset = PasswordReset.new 'user@example.com'
  end

  subject { @password_reset }

  it { should respond_to :email }
  it { should be_valid }

  # TODO concern tests
end
