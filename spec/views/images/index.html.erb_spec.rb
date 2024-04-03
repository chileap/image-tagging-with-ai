require 'rails_helper'

RSpec.describe "images/index", type: :view do
  let(:user) { create(:user) }

  before(:each) do
    assign(:images, [
      Image.create!(file: Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'files', 'image.png'), 'image/png'), user: user, title: "Image Name"),
      Image.create!(file: Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'files', 'image.png'), 'image/png'), user: user, title: "Image Name")
    ])
  end

  it "renders a list of images" do
    render
  end
end
