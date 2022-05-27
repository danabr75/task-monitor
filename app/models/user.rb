class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
  # :registerable,

  # Method to increase the ability to update passwords from console
  def reset_pass password
    self.password = password
    self.password_confirmation = password

    self.reset_password_token = nil
    self.reset_password_sent_at = nil

    # self.invitation_token = nil
    # self.invitation_created_at = nil
    # self.invitation_accepted_at = Time.now.utc
  end
  def reset_pass! password
    reset_pass(password)
    self.save(validate: false)
  end

  def create_new_user! email, password
    User.create!(email: email, password: password)
  end

end
