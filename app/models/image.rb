# == Schema Information
#
# Table name: images
#
#  id         :uuid             not null, primary key
#  file_data  :text
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid
#
# Indexes
#
#  index_images_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Image < ApplicationRecord
  include ImageUploader::Attachment.new(:file)
  belongs_to :user
  acts_as_taggable_on :tags
  acts_as_taggable_tenant :user_id

  validates :title, presence: true
  validates :file_data, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[title created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user taggings]
  end

  def image_size
    return if file_data.blank?
    "#{(file.metadata["size"].to_f / 1024).round(2)} KB"
  end

  def filename
    return if file_data.blank?
    file.metadata["filename"]
  end

  def file_extension
    return if file_data.blank?
    file.metadata["filename"].split(".").last
  end

  def filesize
    return if file_data.blank?
    file.metadata["size"]
  end
end
