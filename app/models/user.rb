class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :first_name, :last_name, :profile_name, :fb_id
  # attr_accessible :title, :body

  validates :first_name, presence: true, format: { with: /\A[a-zA-Z]+\z/, message: 'only use letters' }
  validates :last_name, presence: true, format: { with: /\A[a-zA-Z]+\z/, message: 'only use letters' }
  validates :profile_name, presence: true,
                           uniqueness: true,
                           format: {
                           with: /^[a-zA-Z0-9_-]+$/,
                           message: 'only use letters and numbers'
                           }

  has_many :statuses
  has_many :user_friendships
  has_many :friends, through: :user_friendships, 
                     conditions: { user_friendships: { state: 'accepted' }}
  has_many :pending_user_friendships, class_name: 'UserFriendship',
                                      foreign_key: :user_id,
                                      conditions: { state: 'pending' }
  has_many :pending_friends, through: :pending_user_friendships, source: :friend
  has_many :requested_user_friendships, class_name: 'UserFriendship',
                                      foreign_key: :user_id,
                                      conditions: { state: 'requested' }
  has_many :requested_friends, through: :requested_user_friendships, source: :friend
  has_many :blocked_user_friendships, class_name: 'UserFriendship',
                                      foreign_key: :user_id,
                                      conditions: { state: 'blocked' }
  has_many :blocked_friends, through: :blocked_user_friendships, source: :friend
  has_many :accepted_user_friendships, class_name: 'UserFriendship',
                                      foreign_key: :user_id,
                                      conditions: { state: 'accepted' }
  has_many :accepted_friends, through: :accepted_user_friendships, source: :friend

  def full_name
  	first_name + " " + last_name
  end

  def to_param
    profile_name
  end

  # if fb id is not null, exists and not sillouette, use fb photo

  def photo_url
    if fb_id.nil? or fb_id == ""
      stripped_email = email.strip
      downcased_email = stripped_email.downcase
      hash = Digest::MD5.hexdigest(downcased_email)
      "http://gravatar.com/avatar/#{hash}?&d=mm"
    else
      "http://graph.facebook.com/#{fb_id}/picture?width=70&height=70"
    end
  end

  def sidebar_photo_url
    if fb_id.nil? or fb_id == ""
      stripped_email = email.strip
      downcased_email = stripped_email.downcase
      hash = Digest::MD5.hexdigest(downcased_email)
      "http://gravatar.com/avatar/#{hash}?&d=mm"
    else
      "http://graph.facebook.com/#{fb_id}/picture?width=50&height=50"
    end
  end

  def profile_url
    if fb_id.nil? or fb_id == ""
      stripped_email = email.strip
      downcased_email = stripped_email.downcase
      hash = Digest::MD5.hexdigest(downcased_email)
      "http://gravatar.com/avatar/#{hash}?s=300&d=mm"
    else
      "http://graph.facebook.com/#{fb_id}/picture?width=150&height=150"
    end
  end

  def has_blocked?(other_user)
    blocked_friends.include?(other_user)
  end

end
