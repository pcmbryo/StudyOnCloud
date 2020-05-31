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
end
