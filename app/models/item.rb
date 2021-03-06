class Item < ActiveRecord::Base
	validates :title, :description, :user_id, :deposit, :tags, :postal_code,  presence: true

	belongs_to :user

	has_many :prices, :dependent => :destroy
	has_many :reviews, :dependent => :destroy
	has_many :ratings, :dependent => :destroy
	has_many :users_that_reviewed_this, through: :reviews, source: :user
	has_many :users_that_rated_this, through: :ratings, source: :user
	has_many :transactions, :dependent => :destroy

	accepts_nested_attributes_for :prices, reject_if: :all_blank, allow_destroy: true,
		reject_if: proc { |attributes| attributes[:amount].blank? }

	has_many :pictures, :dependent => :destroy

	#validates :photo,
  #  attachment_content_type: { content_type: /\Aimage\/.*\Z/ },
  #  attachment_size: { less_than: 5.megabytes }

	#has_attached_file :photo, styles: { small: "400x400", med: "800x800", large: "1200x1200" }

	def ratings_by_user(user)
		ratings.find_by(user: user).score
	end

	def total_score
		(self.ratings.sum(:score) / (ratings.count(:user_id).to_f)).round(1)
	end
end
