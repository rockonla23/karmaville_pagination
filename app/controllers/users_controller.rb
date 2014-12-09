class UsersController < ApplicationController
  def index
    @users = User.by_karma.paginate(:page => params[:page], :per_page => 200)
  end
end
