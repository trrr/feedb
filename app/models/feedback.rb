class Feedback < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  before_validation :create_url
  validates :url, presence: true, uniqueness: { case_sensitive: false }, length: {is: 15}
  validates :user_id, presence: true
  validates :title, length: {maximum: 40}

  def to_param
    self.url
  end

  private

    def create_url
      self.url = generate_url
    end

    def generate_url
      ('a'..'z').to_a.shuffle[0,15].join
    end

end
