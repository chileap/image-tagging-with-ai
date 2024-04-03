require 'rails_helper'

RSpec.describe "images/edit", type: :view do
  let(:user) { create(:user) }
  let(:image) {
    Image.create!(file: Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'files', 'image.png'), 'image/png'), user: user, title: "Image Name")
  }

  before(:each) do
    assign(:image, image)
  end

  it "renders the edit image form" do
    render

    assert_select "form[action=?][method=?]", image_path(image), "post" do
    end
  end
end
