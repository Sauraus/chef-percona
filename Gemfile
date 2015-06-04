source 'https://rubygems.org'

chef_version = ENV.fetch("CHEF_VERSION", "12.3.0")

gem "chef", "~> #{chef_version}"
gem "chefspec", "~> 4.2.0"
gem "chef-vault", "~> 2.6.0"

# Uncomment these lines if you want to live on the Edge:
#
# group :development do
#   gem "berkshelf", github: "berkshelf/berkshelf"
#   gem "vagrant", github: "mitchellh/vagrant", tag: "v1.6.3"
# end
#
# group :plugins do
#   gem "vagrant-berkshelf", github: "berkshelf/vagrant-berkshelf"
#   gem "vagrant-omnibus", github: "schisamo/vagrant-omnibus"
# end

gem "berkshelf", "~> 3.2.4"
gem "foodcritic", "~> 4.0.0"
gem "license_finder", "~> 2.0.4"
gem "rake", "~> 10.4.2"
gem "rubocop", "~> 0.31.0"
gem "serverspec", "~> 2.17.0"

group :integration do
  gem "busser-serverspec", "~> 0.5.7"
  gem "kitchen-docker", "~> 2.1.0"
  gem "kitchen-sync", "~> 1.1.1"
  gem "test-kitchen", "~> 1.4.2"
  gem "kitchen-vagrant", "~> 0.18.0"
end
