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

  #def threat
  #end
end

class Board

  def initialize
    @board = generate_board
    place_pieces
  end

  def tile_at(position)     # returns Tile obj at that position
    row, col = position
    @board[row][col]
  end

  private
  def generate_board
    Array.new(8) do |row|
      Array.new(8) { |col| Tile.new(self, [row, col]) }
    end
  end

  def place_pieces
    self.tile_at([0, 0]).occupied_by = Rook.new("black", [0, 0])
    self.tile_at([0, 1]).occupied_by = Knight.new("black", [0, 1])
    self.tile_at([0, 2]).occupied_by = Bishop.new("black", [0, 2])
    self.tile_at([0, 3]).occupied_by = Queen.new("black", [0, 3])
    self.tile_at([0, 4]).occupied_by = King.new("black", [0, 4])
    self.tile_at([0, 5]).occupied_by = Bishop.new("black", [0, 5])
    self.tile_at([0, 6]).occupied_by = Knight.new("black", [0, 6])
    self.tile_at([0, 7]).occupied_by = Rook.new("black", [0, 7])
    8.times {|i| self.tile_at([1, i]).occupied_by = Pawn.new("black", [1, i])}

    8.times {|i| self.tile_at([6, i]).occupied_by = Pawn.new("white", [6, i])}
    self.tile_at([7, 0]).occupied_by = Rook.new("white", [7, 0])
    self.tile_at([7, 1]).occupied_by = Knight.new("white", [7, 1])
    self.tile_at([7, 2]).occupied_by = Bishop.new("white", [7, 2])
    self.tile_at([7, 3]).occupied_by = Queen.new("white", [7, 3])
    self.tile_at([7, 4]).occupied_by = King.new("white", [7, 4])
    self.tile_at([7, 5]).occupied_by = Bishop.new("white", [7, 5])
    self.tile_at([7, 6]).occupied_by = Knight.new("white", [7, 6])
    self.tile_at([7, 7]).occupied_by = Rook.new("white", [7, 7])
  end

end

class Pieces

  attr_reader :color
  attr_accessor :eligible_path, :position

  def initialize(color, position)
    @color = color
    @position = position
  end

end

class Pawn < Pieces

  def initialize(color, position)
    super(color, position)

  end

end

class Bishop < Pieces
  def initialize(color, position)
    super(color, position)

  end

end

class Rook < Pieces
  def initialize(color, position)
    super(color, position)

  end
end

class Knight < Pieces
  def initialize(color, position)
    super(color, position)

  end
end

class Queen < Pieces
  def initialize(color, position)
    super(color, position)

  end
end

class King < Pieces
  def initialize(color, position)
    super(color, position)

  end
end


# #     Methods:
# #     Move
# #     Remove "die"
#
#
# class Players
#   class HumanPlayers
#
#     def my_turn
#
#   #Computer
#
# Game
#   def initialize
#     init Board
#

