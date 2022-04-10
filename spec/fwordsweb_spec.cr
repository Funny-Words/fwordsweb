require "./spec_helper"

describe "fwordsweb" do
  it "renders /api/v1/cword" do
    get "/api/v1/cword"
    response.success?.should be_true
    response.body.should_not be_empty
  end

  it "renders /api/v1/words?q=5" do
    get "/api/v1/words?q=5"
    puts response.status, response.status_code
    #response.success?.should be_true
    response.body.should_not be_empty
  end

  it "renders /api/v1/allwords" do
    get "/api/v1/allwords"
    response.success?.should be_true
    response.body.should_not be_empty
  end
end
