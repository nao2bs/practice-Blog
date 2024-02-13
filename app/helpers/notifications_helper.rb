module NotificationsHelper
    # def unchecked_notifications
    #     @notifications=current_user.passive_notifications.where(checked: false)
    # end

    def mark_as_read
        notification = Notification.find(params[:id])
        notification.update(read: true)
        redirect_to notifications_path
    end
end
