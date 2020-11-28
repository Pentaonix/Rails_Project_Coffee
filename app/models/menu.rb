class Menu < ApplicationRecord
  has_many :menu_items
  has_one_attached :image

  def thumbnail
    return self.image#.variant(resize: "300x300!")
  end
end
