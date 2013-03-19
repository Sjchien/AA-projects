class Tile
  attr_reader :position
  attr_accessor :occupied_by, :in_path

  def initialize(board, position)
    @board, @position = board, position
    @occupied_by = nil
    @in_path = nil
  end

  def inspect
    { position: position,
      occupied_by: occupied_by,
      in_path: in_path
    }.inspect
  end

  def threat
  end

class Board

  def initialize

  end

  def tile_at(position)
    # returns Tile obj at that position
  end

  private

  def generate_board
    Array.new(8) do |row|
      Array.new(8) { |col| Tile.new(self, [row, col]) }
    end
  end

  def place_pieces

  end

end

Pieces  :eligible_path, :color
- position
- possible_moves
- color?
  Pawn
  Bishop
  Rook
  Knight
  King
  Queen

    Methods:
    Move
    Remove "die"


class Players
  class HumanPlayers

    def my_turn

  #Computer

Game
  def initialize
    init Board


