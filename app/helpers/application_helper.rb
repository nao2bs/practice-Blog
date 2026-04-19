module ApplicationHelper
  def display_notice?
    notice.present?
  end

  def display_alert?
    alert.present? && !suppress_sign_in_alert?(alert)
  end

  private

  def suppress_sign_in_alert?(message)
    return false unless devise_controller?
    return false unless controller_name == 'sessions' && action_name == 'new'

    unauthenticated_messages.include?(message)
  end

  def unauthenticated_messages
    @unauthenticated_messages ||= [
      I18n.t('devise.failure.user.unauthenticated', default: ''),
      I18n.t('devise.failure.unauthenticated', default: '')
    ].reject(&:blank?)
  end
end
