class Group < ActiveRecord::Base
  include Extra

  ADMINS = 1
  REFEREES = 2
  MOVIES = 3
  DONORS = 4
  MOVIEMAKERS = 5
  SHOUTCASTERS = 6
  CHAMPIONS = 7
  PREDICTORS = 8
  STAFF = 10

  attr_protected :id, :updated_at, :created_at, :founder_id
  validates_length_of :name, :maximum => 20

  has_and_belongs_to_many :users
  has_many :groupers
  has_many :users, :through => :groupers
  belongs_to :founder, :class_name => "User"

  def to_s
    name
  end

  def can_create? cuser
    cuser and cuser.admin?
  end

  def can_update? cuser
    cuser and cuser.admin?
  end

  def can_destroy? cuser
    cuser and cuser.admin?
  end

  def self.staff
    staff = []
    (find(ADMINS).groupers + find(PREDICTORS).groupers + find(SHOUTCASTERS).groupers + find(STAFF).groupers + find(REFEREES).groupers).each do |g|
      staff << g unless staff.include? g
    end
    staff
  end

  def self.admins
    admins = []
    (find(ADMINS).groupers).each do |g|
      admins << g unless admins.include? g
    end
    admins
  end

  def self.referees
    referees = []
    (find(REFEREES).groupers).each do |g|
      referees << g unless referees.include? g
    end
    referees
  end

  def self.extras
    extras = []
    (find(PREDICTORS).groupers + find(STAFF).groupers).each do |g|
      extras << g unless extras.include? g
    end
    extras
  end

  def self.shoutcasters
    shoutcasters = []
    (find(SHOUTCASTERS).groupers).each do |g|
      shoutcasters << g unless shoutcasters.include? g
    end
    shoutcasters
  end
end
