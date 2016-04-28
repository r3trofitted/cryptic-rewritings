# Step 0: Initial code
class Record
  attr_accessor :title,:year,:stars
  @@records = []
  
  def self.find_by_title(title)
    @@records.find { |record| record.title == title }
  end
  
  def initialize record
    @title = record[:title]
    @year = record[:year]
    @stars = record[:stars] || 1
    add_to_records
  end
  
  def to_s
    "#{@title} (#{@year}) #{'★' * @stars}"
  end
  
      def self.all
        @@records
      end
  
  private
  
def add_to_records
  @@records << self
end
end
