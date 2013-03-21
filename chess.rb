class Tile
  attr_reader :position
  attr_accessor :occupied_by

  def initialize(board, position)
    @board, @position = board, position
    @occupied_by #= nil
  end

  def inspect
    @occupied_by
  end
end

class Board

  def initialize
    @board = generate_board
    print_board = []
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

  def display_board
    @board.each do |row|
      row.each do |tile|
        p tile
      end

    end
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

  def inspect
    self.class.to_s
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

  def eligible_moves(start_pos = self.position, delta = self.delta)
    eligible_moves = []

    delta.each do |dir|
      dir_y, dir_x = dir

      new_spot = [start_pos[0]+dir[0], start_pos[1]+dir[1]]


      eligible_moves << new_spot if valid_tile?(new_spot)
    end

    eligible_moves
  end

  def move(position)
    old_position = self.position
    self.position = position
    @board.tile_at(position).occupied_by = self
    @board.tile_at(old_position).occupied_by = nil
  end
end

class StepPieces < Pieces
end

class SlidingPieces < Pieces

  def eligible_moves_sliding
    eligible_sliding = []

    eligible_dir = eligible_moves.map do |dir|
      [ dir[0] - self.position[0] , dir[1] - self.position[1] ]
    end

    start_pos = self.position
    eligible_dir.each do |eligible_dir|
      test_pos = [start_pos[0] + eligible_dir[0],start_pos[1] + eligible_dir[1]]

      while valid_tile?(test_pos)
        eligible_sliding << test_pos
        test_pos = [test_pos[0] + eligible_dir[0], test_pos[1] + eligible_dir[1]]
      end
    end

    eligible_sliding
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

  def initialize(color, position, board)
    super(color, position, board)
    @delta = [
      [1,0], # typical move
      [2,0], # first move only
      [1,-1],# left kill move
      [1,1]  # right kill move
    ]

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

class Game

  def play
    b = Board.new



  end

end

class HumanPlayer

end