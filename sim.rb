require_relative 'train'

base_train = Copper::Train.new logging: false

10_000.times do
  Copper::Train::STARTING_ROOMS.each do |s_room|
    train = base_train.dup

    train.start s_room

    train.rules.each do |moves, rooms_to_remove|
      moves.times do
        direction = train.available_moves.sample

        train.move_to direction
      end

      if rooms_to_remove.nil?
        raise if train.current_room != 4
      else
        if rooms_to_remove == train.current_room || (rooms_to_remove.is_a?(Array) && rooms_to_remove.include?(train.current_room))
          raise "Cannot remove #{rooms_to_remove}"
        end
        train.remove_rooms rooms_to_remove
      end
    end
  end
end

puts "Done!"
