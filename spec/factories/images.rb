# == Schema Information
#
# Table name: images
#
#  id         :uuid             not null, primary key
#  file_data  :text
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_images_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :image do
    
  end
end
