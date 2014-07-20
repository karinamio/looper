class UserFriendshipDecorator < Draper::Decorator
  delegate_all
  decorates :user_friendship
  
  def friendship_state
  	model.state.titleize
  end
  
  def sub_message
  	case model.state
  	when 'pending'
  	"pending"
    when 'accepted'
  	"accepted"
    when 'requested'
    "requested"
    end
  end

end