billable_roles = ["senior", "developer"]
non_billable_roles = ["junior", "praktykant", "pm", "junior pm", "qa", "junior qa"]

billable_roles.each do |name|
  Role.find_or_create_by(name: name).update_attribute(:billable, true)
end
non_billable_roles.each do |name|
  Role.find_or_create_by(name: name).update_attribute(:billable, false)
end
