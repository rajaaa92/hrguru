roles = ["senior", "developer", "junior", "praktykant", "pm", "junior pm", "qa", "junior qa"]
roles.each { |name| Role.find_or_create_by(name: name) }
