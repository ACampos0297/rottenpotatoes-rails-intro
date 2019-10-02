class Movie < ActiveRecord::Base
	#define all_ratings enumerable collection
	def self.all_ratings
		['G','PG','PG-13','R']
	end
end
