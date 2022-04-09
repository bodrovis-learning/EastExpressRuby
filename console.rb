require_relative 'train'

module Copper
  class Console
    def initialize(logging: true)
      @train = Copper::Train.new logging: logging

      puts "Choose starting room: #{Copper::Train::STARTING_ROOMS}"

      @train.start gets.strip.to_i
    end

    def play
      @train.rules.each do |moves, rooms_to_remove|
        puts "Make #{moves} moves:"

        make_moves moves

        if rooms_to_remove.nil?
          puts 'You should be on DINER now :)'
        else
          remove_rooms rooms_to_remove
        end
      end
    end

    private

    def make_moves(n)
      n.times do
        move = nil

        loop do
          puts "Please make a move: << #{@train.available_moves.join(' ')} >>"

          move = gets.strip.to_sym

          break if @train.can_move? move

          puts "Incorrect move!"
        end

        @train.move_to move
      end
    end

    def remove_rooms(room_nums)
      removed = @train.remove_rooms room_nums
      puts "You can't be on #{removed.join(' ')}, removing..."
    end
  end
end

Copper::Console.new.play
