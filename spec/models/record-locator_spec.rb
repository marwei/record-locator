require 'spec_helper'

require File.expand_path(File.dirname(__FILE__) + '../../../lib/record-locator/record-locator-util')
require File.expand_path(File.dirname(__FILE__) + '../../../models/book')

describe 'RecordLocator' do

  describe 'EncoderAndDecoder' do

    it "Should produce an encoded ID that the original ID can be recovered from" do
      100000.times do
        original = rand(999999999999999)
        encoded = Util::Base::encode(original)
        decoded = Util::Base::decode(encoded)
        original.should == decoded
      end
    end

    it "Should not contain potentially-confusing characters (l,1,0,O,Q) after encode" do
      100000.times do
        original = rand(999999999999999)
        encoded = Util::Base::encode(original)
        encoded = encoded.split("")
        encoded.include?('l').should == false
        encoded.include?('1').should == false
        encoded.include?('0').should == false
        encoded.include?('O').should == false
        encoded.include?('Q').should == false
      end
    end

    it "Should not produce any collisions." do
      originals = {}
      encodeds = {}
      100000.times do
        original = rand(999999)
        next if originals.has_key? original
        originals[original] = true
        encoded = Util::Base::encode(original)
        encodeds.has_key?(encoded).should == false
        encodeds[encoded] = true
      end
    end

  end

  before(:each) do
    publisher_id = rand(999999999999999)
    @book = Book.find_or_create_by(publisher_id: publisher_id)
  end

  it "Should return defined record locator field" do
    @book.record_locator_field.should == :publisher_id
  end

  it "Should not have record locator field nil" do
    @book.encoded_record_locator.should_not be_nil
  end

  it "Should equal ActiveRecord locator decoded value with original ActiveRecord field value" do
    @book.publisher_id.should == Util::Base::decode(Util::Base::encode(@book.publisher_id))
  end

  it "Should Return class type Finder" do
    Book.record_locator.class.to_s.should == 'Finder'
  end

  it "Should Return class type Book" do
    encoded_field = @book.encoded_record_locator
    @book.class.should == Book.record_locator.find(encoded_field).class
  end

  it "Should return Original ActiveRecord Object found by defined encoded filed instead of Active record finder" do
    encoded_field = @book.encoded_record_locator
    @book.should === Book.record_locator.find(encoded_field)
  end

  it "Should return Activerecord Object by passing normal id instead of passing encoded id" do
    publisher_id = @book.publisher_id

    @book.should === Book.record_locator.find(publisher_id)
  end


end
