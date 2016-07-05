module UsersHelper

  def gravatar_for(user)
    digest = Digest::MD5::hexdigest(user.email)
    gravatar_url = "https://secure.gravatar.com/avatar/#{digest}"
    image_tag(gravatar_url, alt: user.name, class: 'gravatar')
  end

  def digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
      BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  module_function :digest
end
