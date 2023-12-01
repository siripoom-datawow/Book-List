class BookRank < ApplicationRecord
  belongs_to :rank 
  belongs_to :book
end
