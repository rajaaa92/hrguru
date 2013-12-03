require 'active_support/core_ext'
require 'konf'

pub_config = YAML.load(ERB.new(File.read('config/config.yml')).result)[Rails.env]
sec_config = YAML.load(ERB.new(File.read('config/sec_config.yml')).result)[Rails.env] rescue {}
AppConfig = Konf.new(pub_config.deep_merge(sec_config))
