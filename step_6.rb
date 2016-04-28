# Step 6: Leveling the abstractions
class Record
  attr_accessor :title,:year,:stars
  @records = []
  
  def self.find_by_title(title)
    @records.find { |record| record.title == title }
  end
  
  def self.register(record)
    @records << record
  end
  
  def initialize(title:, year:, stars: 1)
    self.title, self.year, self.stars = title, year, stars
    add_to_records
  end
  
  def to_s
    "#{title} (#{year}) #{'★' * stars}"
  end
  
  private
  
  def add_to_records
    Record.register(self)
  end
end

## Tests

def test_find_by_title
  # Setup
  rust = Record.new(title: "Rust In Peace", year: 1990, stars: 5)
  Record.register(rust)
  
  # Exercise
  found     = Record.find_by_title("Rust In Peace")
  not_found = Record.find_by_title("Master Of Puppets")
  
  # Verify
  if (found.title == "Rust In Peace") && not_found.nil?
    print "."
  else
    print "F"
  end
end

def test_new_creates_a_record
  # Exercise
  rust = Record.new(title: "Rust In Peace", year: 1990, stars: 5)
  
  # Verify
  if (rust.title == "Rust In Peace") && (rust.year == 1990) && (rust.stars == 5)
    print "."
  else
    print "F"
  end
end

def test_new_adds_the_record
  # Exercise
  rust = Record.new(title: "Rust In Peace", year: 1990, stars: 5)
  
  # Verify
  if Record.find_by_title("Rust In Peace")
    print "."
  else
    print "F"
  end
end

def test_to_s
  # Setup
  rust = Record.new(title: "Rust In Peace", year: 1990, stars: 5)
  
  # Exercise & verify
  if rust.to_s == "Rust In Peace (1990) ★★★★★"
    print "."
  else
    print "F"
  end
end

test_find_by_title
test_new_creates_a_record
test_new_adds_the_record
test_to_s
