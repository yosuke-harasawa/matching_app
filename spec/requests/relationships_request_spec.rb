require 'rails_helper'

RSpec.describe "Relationships", type: :request do

  it "ログインしていなければログインページにリダイレクトする" do
    expect{ post relationships_path }.to_not change{ Relationship.count }
    follow_redirect!
    expect(request.fullpath).to eq login_path
  end

end
