release: bundle exec rails db:migrate
web: export RAILS_ENV=production; export RACK_ENV=production; bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq
