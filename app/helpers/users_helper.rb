module UsersHelper
  def gravatar_for(user, options = { size: 50, classes: classes })#classesはhelloでもなんでもいい
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "#{options[:classes]}")
  end
end
