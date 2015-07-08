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
        expect(original).to eq decoded
      end
    end

    it "Should not contain potentially-confusing characters (l,1,0,O,Q) after encode" do
      100000.times do
        original = rand(999999999999999)
        encoded = Util::Base::encode(original)
        expect(encoded.split("")).not_to include('l', '1', '0', 'O', 'Q')
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
        expect(encodeds.has_key?(encoded)).to be false
        encodeds[encoded] = true
      end
    end

  end

  before(:each) do
    publisher_id = rand(999999999999999)
    @book = Book.find_or_create_by(publisher_id: publisher_id)
  end

  it "Should return defined record locator field" do
    expect(@book.record_locator_field).to eq :publisher_id
  end

  it "Should not have record locator field nil" do
    expect(@book.encoded_record_locator).to_not be_nil
  end

  it "Should equal ActiveRecord locator decoded value with original ActiveRecord field value" do
    expect(@book.publisher_id).to eq Util::Base::decode(Util::Base::encode(@book.publisher_id))
  end

  it "Should Return class type Finder" do
    expect(Book.record_locator).to be_instance_of Finder
  end

  it "Should Return class type Book" do
    encoded_field = @book.encoded_record_locator
    expect(Book.record_locator.find(encoded_field)).to be_a Book
  end

  it "Should return Original ActiveRecord Object found by defined encoded filed instead of Active record finder" do
    encoded_field = @book.encoded_record_locator
    expect(Book.record_locator.find(encoded_field)).to eq @book
  end

  it "Should return Activerecord Object by passing normal id instead of passing encoded id" do
    publisher_id = @book.publisher_id
    expect(Book.record_locator.find(publisher_id)).to eq @book
  end


end
