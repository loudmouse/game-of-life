require 'rspec'

class Cell
  attr_accessor :world, :x, :y

  def initialize(world, x=0, y=0)
    @world = world
    @x = x
    @y = y
    world.cells << self
  end

  def die!
    world.cells -= [self]
  end

  def dead?
    !world.cells.include?(self)
  end

  def neighbors
    @neighbors = []
    world.cells.each do |cell|
      # has a cell to the north
      if self.x == cell.x && self.y == cell.y-1
        @neighbors << cell
      end

      # has a cell to the northeast
      if self.x == cell.x-1 && self.y == cell.y-1
        @neighbors << cell
      end

      # has a cell to the east
      if self.x == cell.x-1 && self.y == cell.y
        @neighbors << cell
      end

      # has a cell to the southeast
      if self.x == cell.x-1 && self.y == cell.y+1
        @neighbors << cell
      end

      # has a cell to the south
      if self.x == cell.x && self.y == cell.y+1
        @neighbors << cell
      end

      # has a cell to the southwest
      if self.x == cell.x+1 && self.y == cell.y+1
        @neighbors << cell
      end

      # has a cell to the west
      if self.x == cell.x+1 && self.y == cell.y
        @neighbors << cell
      end

      # has a cell to the northwest
      if self.x == cell.x+1 && self.y == cell.y-1
        @neighbors << cell
      end

    end

    @neighbors
  end

  def spawn_at(x, y)
    Cell.new(world, x, y)
  end


end

class World
  attr_accessor :cells

  def initialize
    @cells = []
  end

  def tick!
    cells.each do |cell|
      if cell.neighbors.count < 2 || cell.neighbors.count > 3
        cell.die!
      end
    end
  end
end

describe 'game of life' do
  let(:world) { World.new }
  context 'cell utility methods' do
    subject { Cell.new(world) }
    it 'spawn relative to' do
      cell = subject.spawn_at(3,5)
      expect(cell).to be_an_instance_of(Cell)
      expect(cell.x).to be == 3
      expect(cell.y).to be == 5
      expect(cell.world).to be == subject.world
    end

    it 'detects a neighbor to the north' do
      cell = subject.spawn_at(0,1)
      expect(subject.neighbors.count).to be == 1
    end

    it 'detects a neighbor to the northeast' do
      cell = subject.spawn_at(1,1)
      expect(subject.neighbors.count).to be == 1
    end

    it 'detects a neighbor to the east' do
      cell = subject.spawn_at(1,0)
      expect(subject.neighbors.count).to be == 1
    end

    it 'detects a neighbor to the southeast' do
      cell = subject.spawn_at(1,-1)
      expect(subject.neighbors.count).to be == 1
    end

    it 'detects a neighbor to the south' do
      cell = subject.spawn_at(0,-1)
      expect(subject.neighbors.count).to be == 1
    end

    it 'detects a neighbor to the southwest' do
      cell = subject.spawn_at(-1,-1)
      expect(subject.neighbors.count).to be == 1
    end

    it 'detects a neighbor to the west' do
      cell = subject.spawn_at(-1,0)
      expect(subject.neighbors.count).to be == 1
    end

    it 'detects a neighbor to the northwest' do
      cell = subject.spawn_at(-1,1)
      expect(subject.neighbors.count).to be == 1
    end

    it 'dies' do
      subject.die!
      expect(subject.world.cells).not_to include subject

    end
  end

  it 'Rule #1: Any live cell with fewer than two live neighbors dies, as if by underpopulation.' do
    cell = Cell.new(world)
    new_cell = cell.spawn_at(2,0)
    world.tick!
    expect(cell.dead?).to be == true
  end

  it 'Rule #2a: Any live cell with two live neighbors lives on to the next generation.' do
    cell = Cell.new(world)
    new_cell_one = cell.spawn_at(1,0)
    new_cell_two = cell.spawn_at(0,1)
    world.tick!
    expect(cell.dead?).to be == false
  end

  it 'Rule #2b: Any live cell with three live neighbors lives on to the next generation.' do
    cell = Cell.new(world)
    new_cell_one = cell.spawn_at(1,0)
    new_cell_two = cell.spawn_at(0,1)
    new_cell_three = cell.spawn_at(0,1)
    world.tick!
    expect(cell.dead?).to be == false
  end

  it 'Rule #3: Any live cell with more than three live neighbors dies, as if by overpopulation.' do
    cell = Cell.new(world)
    new_cell_one = cell.spawn_at(1,0)
    new_cell_two = cell.spawn_at(0,1)
    new_cell_three = cell.spawn_at(-1,0)
    new_cell_three = cell.spawn_at(0,-1)
    world.tick!
    expect(cell.dead?).to be == true
  end

  it 'Rule #4: Any dead cell with exactly three live neighbors becomes a live cell, as if by reproduction.' do
    
  end
end
