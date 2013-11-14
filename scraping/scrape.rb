require 'nokogiri'
require 'open-uri'
require 'csv'

class ShowScraper
  def initialize(url)
    @doc = Nokogiri::HTML(File.open(open(url)))
    puts "Saved your .csv"
  end

  def extract_names
    @doc.search('.lc').map do |e|
      e.inner_text.slice(1..-2).split.map(&:capitalize).join(' ')
    end
  end

  # document.querySelectorAll('#LS-100')[0].querySelectorAll('p')[1]

  def extract_characters
    output = []
    all_lines = @doc.search('#LS-100')[0].children[5] #=> ~300
    
    325.times do |i|
      if all_lines.children[i].inner_text.include?('.')
        unless all_lines.children[i].inner_text.split[1..-2].join(' ').empty?
          output << all_lines.children[i].inner_text.split[1..-2].join(' ')
        end
      end
    end
    output
  end
  
  def to_csv(name, data)
    CSV.open("lib/data/#{name}.csv", 'w') do |csv|
      data.each { |name| csv << [name] }
    end
  end

  def self.read_csv(name)
    CSV.open("lib/data/#{name}.csv") do |csv|
      csv.readlines().sample.first.slice(1..-2).split.map(&:capitalize).join(' ')
    end
  end
end


# showlist = ShowScraper.new('http://streamallthis.me/tv-shows-list.html')
# name_array = showlist.extract_names
# showlist.to_csv('tvshownames', name_array)


# showlist = ShowScraper.new('http://popwatch.ew.com/2010/06/01/100-greatest-characters-of-last-20-years-full-list/')

# char_array = showlist.extract_characters

# showlist.to_csv('characters', char_array)
