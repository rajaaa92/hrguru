class UserDecorator < Draper::Decorator
  delegate_all

  def name
    "#{first_name} #{last_name}"
  end

  def gravatar_url(size = nil)
    gravatar_id = Digest::MD5.hexdigest(email.downcase)
    "http://www.gravatar.com/avatar/#{gravatar_id}?size=#{size}"
  end
end
