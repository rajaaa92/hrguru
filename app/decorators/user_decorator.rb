class UserDecorator < Draper::Decorator
  delegate_all

  def name
    "#{first_name} #{last_name}"
  end

  def link
    h.link_to name, object
  end

  def project_link
    h.link_to(project.name, project) if project
  end

  def gravatar_url(size = 80)
    gravatar_id = Digest::MD5.hexdigest(email.downcase)
    "http://www.gravatar.com/avatar/#{gravatar_id}?size=#{size}"
  end

  def gravatar_image(options = {})
    size ||= options[:size]
    options.delete(:size)
    h.image_tag gravatar_url(size), options
  end

  def github_link
    github_connected? ? h.link_to(gh_nick, "http://github.com/#{gh_nick}") : "-"
  end
end
