class Image < ApplicationRecord
  include ImageUploader::Attachment.new(:file)
  belongs_to :user
end
