# Step 3: Using our own accessor methods
class Record
  @@records = []
  
  attr_accessor :title,:year,:stars
  
  def self.all
    @@records
  end
  
  def self.find_by_title(title)
    @@records.find { |record| record.title == title }
  end
  
  def initialize(record)
    self.title = record[:title]
    self.year  = record[:year]
    self.stars = record[:stars] || 1
    
    add_to_records
  end
  
  def to_s
    "#{title} (#{year}) #{'★' * stars}"
  end
  
  private
  
  def add_to_records
    @@records << self
  end
end

## Tests

def test_all
  # Setup
  rust = Record.new(title: "Rust In Peace", year: 1990, stars: 5)
  original_records = Record.class_variable_get(:"@@records").dup
  Record.class_variable_set(:"@@records", [rust])
  
  # Exercise
  all = Record.all
  
  # Verify
  if (all.length == 1) && (all.first.title == "Rust In Peace")
    print "."
  else
    print "F"
  end
  
  # Teardown
  Record.class_variable_set(:"@@records", original_records)
end

def test_find_by_title
  # Setup
  rust = Record.new(title: "Rust In Peace", year: 1990, stars: 5)
  Record.all << rust
  
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
  if Record.all.include? rust
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

test_all
test_find_by_title
test_new_creates_a_record
test_new_adds_the_record
test_to_s
