class Image < ApplicationRecord
  include ImageUploader::Attachment.new(:file)
end
