json.array! @users do |user|
  json.id user.id
  json.name user.name
  json.image_url gravatar_for(user, size: 50)
end

