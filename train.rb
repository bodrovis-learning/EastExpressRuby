module Copper
  class Train
    WIDTH = 3
    HEIGHT = 3

    ROOMS = {
      1 => :bar,
      2 => :shower,
      3 => :baggage,
      4 => :diner,
      5 => :engine,
      6 => :club,
      7 => :caboose,
      8 => :mail,
      9 => :staff
    }.freeze

    STARTING_ROOMS = [2, 4, 6, 8].freeze
    MOVES = {
      up: -HEIGHT,
      down: HEIGHT,
      left: -1,
      right: 1
    }

    attr_reader :current_room

    def initialize(logging: true)
      @available_rooms = ROOMS.dup
      @logging = logging

      print_grid
    end

    def start(starting_room)
      raise "Incorrect starting room" unless STARTING_ROOMS.include?(starting_room)

      @current_room = starting_room

      print_grid
    end

    def can_move?(direction)
      n = MOVES[direction]
      return unless n

      target_room = current_room + n

      target_room.positive? &&
        target_room <= ROOMS.length &&
        !(direction == :left && ((current_room - 1) % WIDTH).zero?) &&
        !(direction == :right && (current_room % WIDTH).zero?) &&
        @available_rooms[target_room]
    end

    def available_moves
      MOVES.keys.keep_if {|m| can_move?(m)}
    end

    def move_to(direction)
      return unless can_move?(direction)

      send direction
    end

    def remove_rooms(*numbers)
      removed_rooms = numbers.flatten.map do |number|
        raise "Can't remove room: #{number}" unless @available_rooms.key? number

        @available_rooms[number] = nil

        ROOMS[number]
      end

      print_grid

      removed_rooms
    end

    def rules
      [
        [4, 9],
        [5, 6],
        [2, 8],
        [3, [3, 7]],
        [3, 2],
        [1, nil]
      ]
    end

    private

    def up
      @current_room += MOVES[:up]
      print_grid
    end

    def down
      @current_room += MOVES[:down]
      print_grid
    end

    def left
      @current_room += MOVES[:left]
      print_grid
    end

    def right
      @current_room += MOVES[:right]
      print_grid
    end

    def print_grid
      return unless @logging

      puts "\n\n"

      @available_rooms.each_slice(WIDTH) do |rooms|
        rooms.each do |room_data|
          room_name = room_data[1].
            then {|name| room_data[0] == current_room ? name.upcase : name}

          print room_name, "\t\t"
        end
        puts "\n\n\n"
      end

      puts "\n\n"
    end
  end
end
