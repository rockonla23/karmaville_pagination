# require_relative '../../app/models/user'
namespace :db do
  task :update_user_karma_and_full_name => :environment do
    # users = User.all
    puts "updating karma and user fullname"
    User.find_each do |user|
      user.update_total_karma
      user.create_full_name
    end
  end
end