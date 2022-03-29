class Image < ApplicationRecord
  belongs_to :property
  has_one_attached :img
end
