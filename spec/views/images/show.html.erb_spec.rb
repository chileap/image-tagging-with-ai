require 'rails_helper'

RSpec.describe "images/show", type: :view do
  let(:user) { create(:user) }

  before(:each) do
    assign(:image, Image.create!(file: Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'files', 'image.png'), 'image/png'), user: user, title: "Image Name"))
  end

  it "renders attributes in <p>" do
    render
  end
end
