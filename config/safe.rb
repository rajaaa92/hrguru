safe do

  db_file = YAML.load_file('config/mongoid.yml')
  mongoid_config = db_file['production']
  mongodump do
    database mongoid_config['database']
  end

  # store backups on s3
  # s3_file = YAML.load_file('config/sec_config.yml')
  # s3_config = (s3_file['production'] || s3_file['beta'])['s3']
  # s3 do
  #   key     s3_config['access_key_id']
  #   secret  s3_config['secret_access_key']
  #   bucket  'hrguru_production'
  # end

  keep do
    local 10
    # s3 120 # uncomment if you are using s3 backup
  end

  local do
    path "~/db_backups"
  end
end
