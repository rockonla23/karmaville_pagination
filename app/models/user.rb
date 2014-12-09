class User < ActiveRecord::Base
  has_many :karma_points

  attr_accessible :first_name, :last_name, :email, :username, :total_karma, :full_name

  validates :first_name, :presence => true
  validates :last_name, :presence => true

  validates :username,
            :presence => true,
            :length => {:minimum => 2, :maximum => 32},
            :format => {:with => /^\w+$/},
            :uniqueness => {:case_sensitive => false}

  validates :email,
            :presence => true,
            :format => {:with => /^[\w+\-.]+@[a-z\d\-.]+\.[a-z]+$/i},
            :uniqueness => {:case_sensitive => false}


  def self.by_karma
    order('total_karma DESC, id ASC')
  end

  def update_total_karma
    self.update_attribute(:total_karma, self.karma_points.sum(:value))
  end

  def create_full_name
    self.update_attribute(:full_name, "#{self.first_name} #{self.last_name}")
  end

  def self.page(page_num=nil)
    entries_per_page = 100
    total_pages = User.all.length / entries_per_page
    page_num = 1 if page_num.nil? || page_num <= 0
    page_num = total_pages if page_num > total_pages
    User.by_karma.limit(entries_per_page).offset((page_num - 1) * entries_per_page)
  end
end
