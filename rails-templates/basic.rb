gem_group :development, :test do
  gem "rspec-rails"
  gem "factory_bot_rails"
end

gem_group :development do
  gem "rails_live_reload"
end

if File.exist?("../.tool-versions")
  FileUtils.cp("../.tool-versions", ".tool-versions")
end

after_bundle do
  rails_command "g rspec:install"

  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end
