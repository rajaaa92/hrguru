require 'netguru'
namespace :netguru do
  desc "Run a backup and save locally"
  task :backup, :local do |t, args|
    args.with_defaults(local: false)
    cmd = "bundle exec astrails-safe config/safe.rb #{'--local' if args[:local]}"
    Netguru::Api.post("/backup", "payload[project_name]" => "hrguru") if system(cmd)
  end
end
