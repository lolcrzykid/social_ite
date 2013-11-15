require "socialite/version"
require 'csv'
module Socialite
  class TVShows 

    class << self

      def name
        read_csv('tvshownames')
      end

      def character_name
        read_csv('characters')
      end

      def read_csv(file_name)
        CSV.open("lib/data/#{file_name}.csv") do |csv|
          csv.readlines().sample.first
        end
      end

    end

  end
end
