class Tile
  attr_reader :position
  attr_accessor :occupied_by

  def initialize(board, position)
    @board, @position = board, position
    @occupied_by #= nil
  end

  def inspect
    { position: position,
      occupied_by: occupied_by
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

  def piece_at(position)
    row, col = position
    tile = @board[row][col]
    tile.occupied_by unless tile.nil?
  end

  private
  def generate_board
    Array.new(8) do |row|
      Array.new(8) { |col| Tile.new(self, [row, col]) }
    end
  end

  def place_pieces
    self.tile_at([0, 0]).occupied_by = Rook.new("black", [0, 0], self)
    self.tile_at([0, 1]).occupied_by = Knight.new("black", [0, 1], self)
    self.tile_at([0, 2]).occupied_by = Bishop.new("black", [0, 2], self)
    self.tile_at([0, 3]).occupied_by = Queen.new("black", [0, 3], self)
    self.tile_at([0, 4]).occupied_by = King.new("black", [0, 4], self)
    self.tile_at([0, 5]).occupied_by = Bishop.new("black", [0, 5], self)
    self.tile_at([0, 6]).occupied_by = Knight.new("black", [0, 6], self)
    self.tile_at([0, 7]).occupied_by = Rook.new("black", [0, 7], self)
    8.times {|i| self.tile_at([1, i]).occupied_by = Pawn.new("black", [1, i], self)}

    8.times {|i| self.tile_at([6, i]).occupied_by = Pawn.new("white", [6, i], self)}
    self.tile_at([7, 0]).occupied_by = Rook.new("white", [7, 0], self)
    self.tile_at([7, 1]).occupied_by = Knight.new("white", [7, 1], self)
    self.tile_at([7, 2]).occupied_by = Bishop.new("white", [7, 2], self)
    self.tile_at([7, 3]).occupied_by = Queen.new("white", [7, 3], self)
    self.tile_at([7, 4]).occupied_by = King.new("white", [7, 4], self)
    self.tile_at([7, 5]).occupied_by = Bishop.new("white", [7, 5], self)
    self.tile_at([7, 6]).occupied_by = Knight.new("white", [7, 6], self)
    self.tile_at([7, 7]).occupied_by = Rook.new("white", [7, 7], self)
  end

end

class Pieces

  attr_reader :color, :delta
  attr_accessor :eligible_paths, :position

  def initialize(color, position, board)
    @color = color
    @position = position
    @board = board
  end

  def in_bounds?(position)
    bounds = 0..7
    bounds.include?(position[0]) && bounds.include?(position[1])
  end

  def valid_tile?(position)
    if in_bounds?(position)
      if @board.piece_at(position).nil? || @board.piece_at(position).color != self.color
        true
      else
        false
      end
    else
      false
    end
  end

  def eligible_moves        # for step pieces
    eligible_moves = []
    start_pos = self.position

    self.delta.each do |dir|
      dir_y, dir_x = dir

      new_spot = [start_pos[0]+dir[0], start_pos[1]+dir[1]]


      eligible_moves << new_spot if valid_tile?(new_spot)
    end

    eligible_moves
  end

#   def move
#     # will utilize the Pieces's position, color, Deltas
#
#     # case self
# #     when self.class == Pawn
# #       # account for kill, must be aware of adjacet enemies
# #     when self.class == Rook
# #       # account for depth, 4 directions
# #     when self.class == Knight
# #       # if eligible_moves.count > 0, then move
# #       #       if enemy piece is @ new_spot, then capture
# #     when self.class == Bishop
# #       # account for depth, 4 directions
# #     when self.class == Queen
# #       # account for depth, 8 directions
# #     when self.class == King
# #       # account for checkmate
# #     end
#
#     # step pieces
#     # move into eligible spots (exception case for Pawn)
#
#     # sliding pieces
#     # find depth using BFS
#     # move into eligible spots
#   end
end

class StepPieces < Pieces
  #   if self.color == "white"          # flip y coordinate if "white"
  #     self.delta.each do |coor|
  #       new_spot = [self.position[0]-coor[0], self.position[1]+coor[1]]
  #
  #       # move to empty tile
  #       if in_bounds?(new_spot) && @board.piece_at(new_spot) == nil
  #         eligible_moves << new_spot
  #       # capture enemy
  #       elsif in_bounds?(new_spot) && @board.piece_at(new_spot).color != self.color
  #         eligible_moves << new_spot
  #       else
  #         puts "ineligible move"
  #       end
  #     end
  #   else
  #     self.delta.each do |coor|
  #       new_spot = [self.position[0]+coor[0], self.position[1]+coor[1]]
  #
  #       # move to empty tile
  #       if in_bounds?(new_spot) && @board.piece_at(new_spot) == nil
  #         eligible_moves << new_spot
  #       # capture enemy
  #       elsif in_bounds?(new_spot) && @board.piece_at(new_spot).color != self.color
  #         eligible_moves << new_spot
  #       else
  #         puts "ineligible move #{new_spot}"
  #       end
  #     end
  #   end
  #
  #   eligible_moves
  # end
end

class SlidingPieces < Pieces

  def eligible_moves
    eligible_moves = []
    start_pos = self.position

    self.delta.each do |dir|
      dir_y, dir_x = dir

      while valid_tile?(start_pos)
        if self.color == "white"
          new_spot = [start_pos[0]-dir[0], start_pos[1]+dir[1]]
        else
          new_spot = [start_pos[0]+dir[0], start_pos[1]+dir[1]]
        end

        p new_spot
        eligible_moves << new_spot
        start_pos = new_spot
      end
    end

    eligible_moves
  end
end

class King < StepPieces
  def initialize(color, position, board)
    super(color, position, board)
    @delta = [
      [-1,-1],[-1,0],[-1, 1],
      [ 0,-1],       [ 0, 1],
      [ 1,-1],[ 1,0],[ 1, 1]
    ]

  end
end

class Knight < StepPieces

  def initialize(color, position, board)
    super(color, position, board)
    @delta = [
      [-1,-2],[-2,-1],[-2,1],[-1, 2],
      [ 1,-2],[ 2,-1],[ 2,1],[ 1, 2]
    ]
  end
end

class Pawn < StepPieces

  pawn_move = [0,1]
  pawn_first_move = [0,2]
  #
  #

  def initialize(color, position, board)
    super(color, position, board)
    @delta = [
      [1,0], # typical move
      [2,0], # first move only
      [1,-1],# left kill move
      [1,1]  # right kill move
    ]

  end # y-coor needs to be negative for white peices

  # def eligible_move
#     x = DELTA[0][0]
#     y = DELTA[0][1]
#     eligible_moves = []
#
#     puts eligible_moves
#
#     if self.color == "black" && @board.tile_at([position[0]+y,position[1]+x]).occupied_by.nil?
#       eligible_moves << @board.tile_at([position[0]+y,position[1]+x]).position
#       puts "black pawn eligible move #{eligible_moves}"
#     elsif self.color == "white" && @board.tile_at([position[0]-y,position[1]+x]).occupied_by.nil?
#       eligible_moves << @board.tile_at([position[0]-y,position[1]+x]).position
#       puts "white pawn eligible move #{eligible_moves}"
#     else
#       puts "no eligible move"
#     end
#
#     eligible_moves
#   end

  def kill
    x = DELTA[2][0]
    y = DELTA[2][1]
  end
end

class Rook < SlidingPieces
  def initialize(color, position, board)
    super(color, position, board)
    @delta = [
      [ 0,-1],  # vertical north
      [ 0, 1],  # vertical south
      [ 1, 0],  # horizontal east
      [-1, 0]   # horizontal west
    ]

  end
end

class Bishop < SlidingPieces
  def initialize(color, position, board)
    super(color, position, board)
    @delta = [
      [ 1, 1],   # southeast
      [ 1,-1],   # southwest
      [-1, 1],   # northeast
      [-1,-1]    # northwest
    ]

  end

end

class Queen < SlidingPieces
  def initialize(color, position, board)
    super(color, position, board)
    @delta = [
      [ 0,-1],   # vertical north
      [-1, 1],   # northeast
      [ 1, 0],   # horizontal east
      [ 1, 1],   # southeast
      [ 0, 1],   # vertical south
      [ 1,-1],   # southwest
      [-1, 0],   # horizontal west
      [-1,-1]    # northwest
    ]

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

