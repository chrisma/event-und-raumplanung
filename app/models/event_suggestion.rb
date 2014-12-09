class EventSuggestion < ActiveRecord::Base
  include DateTimeAttribute
  has_and_belongs_to_many :rooms
  accepts_nested_attributes_for :rooms 

  date_time_attribute :starts_at
  date_time_attribute :ends_at
end