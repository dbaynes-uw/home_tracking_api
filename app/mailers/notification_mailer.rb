class NotificationMailer < ApplicationMailer
  def notification_email_view
    @area = params[:area]
    mail(to: "dlbaynes@gmail.com", subject: "You've got Mail")
  end

end