# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :images, dependent: :destroy
  acts_as_tagger

  def images_count_by_tag(tag)
    images.tagged_with(tag).count
  end

  def all_tags
    not_used_tags = ActsAsTaggableOn::Tag.where(taggings_count: 0).pluck(:name)
    ActsAsTaggableOn::Tag.where(name: not_used_tags.push(owned_tags.pluck(:name)).flatten.uniq)
  end
end
