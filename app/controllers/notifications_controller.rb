class NotificationsController < ApplicationController
  # Get all notifications and assign them to the instance variable @notifications.
  def index
    @notifications = Notification.all
  end

  # def index
  #   @notifications=current_user.passive_notifications.page(params[:page]).per(10)
  #   @notifications.where(checked: false).each do |notification|
  #     notification.update_attributes(checked: true)
  #   end
  # end

  # A method to create a new notification, set the user_id, and handle the save operation.
  def create
    @notification = Notification.new(notification_params)
    @notification.user_id = current_user.id # set ID of current user

    if @notification.save
      # new notification saved
      redirect_to @notification, notice: 'Notification was successfully created.'
    else
      # not new notification saved
      render :new
    end
  end

  private

  # A method that returns the permitted parameters for the notification, requiring the notification parameter and permitting only the content parameter.
  def notification_params
    params.require(:notification).permit(:content)
  end
  # def index
  #   @notifications = Notification.includes(:comment).all
  # end

  # def mark_as_read
  #   notification = Notification.find(params[:id])
  #   notification.update(read: true)
  #   redirect_to notifications_path
  # end
end
