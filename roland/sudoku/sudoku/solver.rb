# where is processing handled if get from cli or text?

module Sudoku
  class Solver

    attr_reader :puzzle

    def initialize(puzzle)
      @puzzle = puzzle
    end

    def valid?(row, col, n)
      if n > 9 || n < 0
        false
      elsif puzzle.get_row(row).include?(n)
        false
      elsif puzzle.get_column(col).include?(n)
        false
      elsif puzzle.get_block_for(row, col).include?(n)
        false
      else
        true
      end
    end


    def solve!
      # counter = 0
      col = row = 0
      n = 1
      while true
        if valid?(row, col, n)
          puzzle.set(row, col, n)
          if row >= 8 && col >= 8
            break
          else
            row, col = puzzle.next_cell(row, col) # based on x,y find which cell to go to next
            n = 1 # reset to zero (which will be incremented at end of while loop), so when the next cell is checked it starts checking from 1 (n=1)
          end
        elsif n >= 9 # ... either we've gone through a cycle of n=1-9 (i.e. we've tried every number and none work), so we must go back to the previous non-fixed_values cell
          puzzle.set(row, col, 0)
          row, col = puzzle.previous_cell(row, col) # find the previous cell to go to
          n = puzzle.get(row, col) + 1
        else
          n += 1
        end

        # counter += 1
        # if counter%500000 ==0
        #   puts puzzle
        # end

      end

      puzzle

    end



  end
end
