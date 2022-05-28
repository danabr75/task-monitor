class IgnorableWindow < ApplicationRecord

  RELATIVE_TIME_WINDOW = Proc.new { |iw|
    current_time = Time.now.utc
    hour, minute = iw.start_time.split(":")
    # https://apidock.com/rails/Time/change
    start = current_time.change(hour: hour.to_i, min: minute.to_i)
    hour, minute = iw.stop_time.split(":")
    stop  = current_time.change(hour: hour.to_i, min: minute.to_i)

    # stop is behind start, which means it refers to the next day
    if start > stop
      stop  = (current_time + 1.day).change(hour: hour.to_i, min: minute.to_i)
    end
    start..stop
  }

  def time_window
    RELATIVE_TIME_WINDOW.call(self)
  end

  def time_window_active?
    time_window.cover?(Time.now.utc)
  end

  validates :start_time, presence: true, format: { with: /\A([0-9]|0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]\z/, message: "please valid time: ??:??"}
  validates :stop_time, presence: true,  format: { with: /\A([0-9]|0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]\z/, message: "please valid time: ??:??"}
  belongs_to :task
end