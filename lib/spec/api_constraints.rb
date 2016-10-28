require "rails_helper"

describe ApiConstraints do
  let(:api_constraints_v1) { ApiConstraints.new(version: 1) }
  let(:api_constraints_v2) { ApiConstraints.new(version: 2, default: true)}

  it "returns version 1 as specified in request header" do 
    req = double(host: "http://api.spring_ghana.dev:300", headers: {"Accept" => "application/vnd.spring_ghana.v1"})
    expect(api_constraints_v1.matches?(req)).to be_truthy
  end

  it "returns version 2 as default without any accept headers parameter" do 
    req = double(host: "http://api.spring_ghana.dev:300")
    expect(api_constraints_v2.matches?(req)).to be_truthy
  end
end