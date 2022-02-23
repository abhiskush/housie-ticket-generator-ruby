# frozen_string_literal: false

# Housie class to generate a random ticket
class Housie
  def initialize
    # initializing ticket as 3X9 grid
    @ticket = Array.new(3) { Array.new(9, nil) }
    @rows = 3
    @columns = 9
    @per_row_count = 5
    @errors = [] # to save errors if any
  end

  # randomly select 5 cells in each row
  def select_random_indices
    @shuffle = (0...@columns).to_a.shuffle
    @row1 = @shuffle[0..2] + @shuffle[3..8].sample(2)
    @row2 = @shuffle[3..5] + (@shuffle[0..1] + @shuffle[6..8]).sample(2)
    @row3 = @shuffle[6..8] + @shuffle[0..5].sample(2)
  end

  # initialize randonly selected cells to indetify them
  def initialize_selected_indices
    @per_row_count.times do |i|
      @ticket[0][@row1[i]] = 0
      @ticket[1][@row2[i]] = 0
      @ticket[2][@row3[i]] = 0
    end
  end

  # creating column range
  def get_range(col)
    [col.zero? ? 1 : col * 10, col == 8 ? 90 : col * 10 + 9]
  end

  # assign a number to all selected cells within the range defined for a particular column
  def assign_ticket_numbers
    @columns.times do |col|
      start_range, end_range = get_range(col)

      # since numbers are sorted in a column therefore sorting and reversing the selection
      ticket_numbers = (start_range..end_range).to_a.sample(@columns).sort.reverse

      @rows.times { |row| @ticket[row][col] = ticket_numbers.pop unless @ticket[row][col].nil? }
    end
  end

  # start generation of ticket
  def generate_ticket
    select_random_indices
    initialize_selected_indices
    assign_ticket_numbers
  end

  # printing a row
  def display_row(row)
    row.each { |col| print "| #{col.to_s.rjust(2)} " }
    puts "|\n"
  end

  # start printing the ticket
  def display_ticket
    puts '-' * (@ticket.first.length * 5 + 1)
    @ticket.each do |row|
      display_row row
      puts '-' * (@ticket.first.length * 5 + 1)
    end
  end

  # ====================================== TESTING ======================================

  # check if any blank cloumn found
  def any_column_blank?(column_values, col)
    @errors << "Column #{col + 1}: Blank column found!" if column_values.length.zero?
  end

  # check if filled cells are sorted in a column
  def all_column_sorted?(column_values, col)
    @errors << "Column #{col + 1}: Column numbers are not soted!" if column_values != column_values.sort
  end

  # check if all filled cells are in defined range for that particular column
  def all_column_values_in_range?(column_values, col)
    start_range, end_range = get_range(col)
    return unless column_values.any? { |val| val < start_range || val > end_range }

    @errors << "Column #{col + 1}: Column numbers are out of range!"
  end

  # test if each column satisfies the defined rule
  def each_column_rule_satisfy?
    @columns.times do |col|
      column_values = []
      @rows.times { |row| column_values << @ticket[row][col] unless @ticket[row][col].nil? }
      any_column_blank?(column_values, col)
      all_column_sorted?(column_values, col)
      all_column_values_in_range?(column_values, col)
    end
  end

  # check if each row has exactly 5 filled cells
  def row_has_five_filled_cells?(row)
    @errors << "Row #{row + 1}: Row has not five filled cells" if @ticket[row].compact.length != 5
  end

  # test if each row satisfies the defined rule
  def each_row_rule_satisfy?
    @rows.times { |row| row_has_five_filled_cells?(row) }
  end

  # start running the test
  def pass_test
    each_column_rule_satisfy?
    each_row_rule_satisfy?
    puts ['Some error occurred:', @errors] if @errors.any?
  end
end

housie = Housie.new
housie.generate_ticket
housie.display_ticket
housie.pass_test
