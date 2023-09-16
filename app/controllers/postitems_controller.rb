class PostitemsController < ApplicationController

  def self.ransackable_attributes(auth_object = nil)
["date", "explanatory_text", "id", "moving_method", "number_of_times", "place", "post_id", "time"]
end

end
