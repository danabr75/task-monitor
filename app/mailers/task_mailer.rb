class TaskMailer < ActionMailer::Base
  default from: ENV["DEFAULT_FROM_ADDRESS"]
  layout "mailer"

  # TaskMailer.send_inactive(Task.last).deliver
  def send_inactive task
    @task = task
    mail(to: ENV["DEFAULT_TO_ADDRESS"], subject: "#{task.name} was inactive")
  end
end
