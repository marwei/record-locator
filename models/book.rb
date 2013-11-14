require File.expand_path(File.dirname(__FILE__) + '/../lib/record-locator')

class Book < ActiveRecord::Base
  extend RecordLocator
  has_record_locator :publisher_id
end
