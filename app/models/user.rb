class User < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :tracks
  has_many :contents, through: :tracks

  has_attached_file :avatar, 
    :styles => { :medium => "600x600>", :thumb => "100x100#" }, 
    :default_url => "/default_user.png",
    :use_timestamp => false,
    :url => ':style/:hash.:extension',
    :path => 'uploads/users/:url'

  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
         
end
