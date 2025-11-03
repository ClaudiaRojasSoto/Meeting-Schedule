class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def index
    @users_count = User.count
    @meetings_count = Meeting.count
    @upcoming_meetings = Meeting.upcoming.limit(5)
  end

  private

  def require_admin
    redirect_to root_path, alert: "No tienes permisos para acceder a esta sección." unless current_user&.admin?
  end
end
