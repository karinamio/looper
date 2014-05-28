class UserFriendshipDecorator < Draper::Base
  decorates :user_friendship
  def friendship_state
  	model.state.titleize
  end
  def sub_message
  	"<h3>Do you really want to be friends with Bob?</h3>"
  end
end
