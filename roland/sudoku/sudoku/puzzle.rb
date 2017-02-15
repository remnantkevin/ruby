module Sudoku

  class InvalidCellRequestException < RuntimeError; end
  class InvalidNextCellRequestException < InvalidCellRequestException; end
  class InvalidPreviousCellRequestException < InvalidCellRequestException; end

  class Puzzle
    attr_accessor :rows, :fixed_values

    def initialize(rows, fixed_values)
      @rows = rows
      @fixed_values = fixed_values
      # print_l
      # puts "---"*20
    end

    def get(row, col)
      get_row(row)[col]
    end

    def set(row, col, value)
      get_row(row)[col] = value
    end

    def get_row(row)
      rows[row]
    end

    def get_column(col)
      (0...rows.length).map {|row| get(row, col)}
    end

    def get_block_for(row, col)
      block_start_row, block_start_col = row/3*3, col/3*3
      block = []
      (0..2).each do |r|
        (0..2).each do |c|
          block << get(block_start_row + r, block_start_col + c)
        end
      end
      block
    end

    def fixed_value?(row, col)
      fixed_values.include?([row, col])
    end

    # find next cell that's not a fixed_values cell or beyond the boundaries
    # the highest x,y position this get's called at is y==4 && x==3
    def next_cell(row, col)
      col += 1
      if col > 8
        row += 1
        col = 0
      end

      if row > 8
        raise InvalidNextCellRequestException, "End of puzzle reached"
      elsif !fixed_value?(row, col)
        [row, col]
      else
        next_cell(row, col)
      end
    end

    # find previous cell that's not a fixed_values cell or beyond the boundaries
    # the highest x,y position this get's called at is y==4 && x==4
    def previous_cell(row, col)
      col -= 1
      if col < 0
        row -= 1
        col = 8
      end

      if row < 0
        raise InvalidPreviousCellRequestException, "Beginning of puzzle reached"
      elsif !fixed_value?(row, col)
        [row, col]
      else
        previous_cell(row, col)
      end
    end

    # edit to use get row..
    def to_s
      str = ""
      count_row = 0
      count_col = 0
      str << "-"*25 << "\n"
      rows.each do |row|
        row.each do |ele|
          str << ele.to_s << " "
          count_col += 1
          if count_col == 3
            str << "| "
            count_col = 0
          end
        end
        count_row += 1
        if count_row == 3
          str << "\n" << "-"*25 << "\n"
          count_row = 0
        else
          str << "\n"
        end
      end
      str << "-"*25
    end

  end
end
