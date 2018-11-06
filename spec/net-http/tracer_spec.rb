require 'spec_helper'
require 'net/http/tracer'

RSpec.describe Net::Http::Tracer do
  describe "Class Methods" do
    it { should respond_to :instrument }
    it { should respond_to :patch_request }
  end

  # @mock_httpdd = mock("http")

end
