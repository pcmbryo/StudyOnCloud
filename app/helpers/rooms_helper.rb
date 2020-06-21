module RoomsHelper
  # 定員数の配列を返す
  def room_capacity
    room_capacity = 10
    array = []
    room_capacity.times do |i|
      array.push(i + 1)
    end
    array
  end

  # 曜日を日本語に変換する
  def day_to_japanese(room)
    day = room.room_start_datetime.strftime("%a")
    case day
    when "Sun" then
      return "日"
    when "Mon" then
      return "月"
    when "Tue" then
      return "火"
    when "Wed" then
      return "水"
    when "Thu" then
      return "木"
    when "Fri" then
      return "金"
    when "Sat" then
      return "土"
    else
      return ""
    end
  end

  # 勉強会の時間を返す
  def room_hours(room)
    room_hours = (room.room_end_datetime - room.room_start_datetime) / 3600
    hour = room_hours.to_i
    minute = room_hours - hour
    if minute > 0.5
      minute = ".5"
    else
      minute = ""
    end
    return hour.to_s + minute + "時間"
  end

  # 現在の日付を返す
  def date_now
    Time.zone.now.strftime("%Y/%m/%d")
  end

  # 時刻の選択肢を返す
  def time_option
    time_option = []
    meridian = ["午前", "午後"]
    hour = ["12", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"]
    hour24 = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
    minute = ["00", "30"]
    meridian.each do |meridian|
      hour.each_with_index do |hour, i|
        minute.each do |minute|
          if meridian == "午後"
            time_option.push([meridian + hour + ":" + minute, (hour24[i] + 12).to_s + ':' + minute])
          else
            time_option.push([meridian + hour + ":" + minute, hour24[i].to_s + ":" + minute])
          end
        end
      end
    end
    time_option
  end

  # 開始時刻の初期値を返す
  def start_time_init
    now = Time.zone.now
    now.hour * 2 + now.min / 30 + 1
  end

  # 終了時刻の初期値を返す
  def end_time_init
    start_time_init + 2
  end

  # 入力用データから保存用データへ変換する
  def parse_room(room_confirm)
    room_start_datetime = Time.zone.parse(room_confirm.room_start_date + " " + room_confirm.room_start_time)
    room_end_datetime = Time.zone.parse(room_confirm.room_end_date + " " + room_confirm.room_end_time)
    
    if room_start_datetime < Time.zone.now
      flash[:danger] = "現在時刻より前に勉強会は開催できません"
      return
    end

    if room_start_datetime >= room_end_datetime
      flash[:danger] = "終了日時が開始日時より前になっています"
      return
    end

    room = Room.new(room_name: room_confirm.room_name,
      room_detail: room_confirm.room_detail,
      room_start_datetime: room_start_datetime,
      room_end_datetime: room_end_datetime,
      room_capacity: room_confirm.room_capacity,
      user_id: room_confirm.user_id)
    
    return room
  end
end

