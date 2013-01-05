# == Schema Information
#
# Table name: media_items
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  author       :string(255)
#  publisher    :string(255)
#  published_on :string(255)
#  unit_cost    :integer
#  category     :string(255)
#  currency     :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class MediaItemTest < ActiveSupport::TestCase
  
  test " presence validations" do
    new_media_item = MediaItem.create(title: "", author: "author", publisher: "publisher", published_on: Date.today, unit_cost: 59.0, currency: "USD", category: "Audiobook")
    assert !new_media_item.valid?
    assert new_media_item.errors.messages[:title].include?("cannot be blank")
    new_media_item = MediaItem.create(title: "title", author: "", publisher: "publisher", published_on: Date.today, unit_cost: 59.0, currency: "USD", category: "Audiobook")
    assert !new_media_item.valid?
    assert new_media_item.errors.messages[:author].include?("cannot be blank")
    new_media_item = MediaItem.create(title: "title", author: "author", publisher: "", published_on: Date.today, unit_cost: 59.0, currency: "USD", category: "Audiobook")
    assert !new_media_item.valid?
    assert new_media_item.errors.messages[:publisher].include?("cannot be blank")
    new_media_item = MediaItem.create(title: "title", author: "author", publisher: "publisher", published_on: nil, unit_cost: 59.0, currency: "USD", category: "Audiobook")
    assert !new_media_item.valid?
    assert new_media_item.errors.messages[:published_on].include?("can't be blank")
    new_media_item = MediaItem.create(title: "title", author: "author", publisher: "publisher", published_on: Date.today, unit_cost: 59.0, currency: "USD", category: "")
    assert !new_media_item.valid?
    assert new_media_item.errors.messages[:category].include?("cannot be blank")
    new_media_item = MediaItem.create(title: "title", author: "author", publisher: "publisher", published_on: Date.today, unit_cost: 59.0, currency: "USD", category: "Audiobook")
    assert new_media_item.valid?
  end

  test "update existing record" do
    assert MediaItem.create(:title=>"Refactoring",:author=>"Martin Fowler",:publisher=>"Addison Wesley",:published_on=>"8-Jul-99", :unit_cost => 50.0, currency: "USD", category: "Book")
    media_item = MediaItem.find_by_title_and_author_and_publisher_and_published_on("Refactoring", "Martin Fowler", "Addison Wesley", "8-Jul-99")
    new_cost = 100.0
    media_item.update_attributes({:unit_cost => new_cost})
    assert_equal new_cost, media_item.unit_cost
  end

  test "can not create a new record if unique" do
    assert MediaItem.create(:title=>"Refactoring",:author=>"Martin Fowler",:publisher=>"Addison Wesley",:published_on=>"8-Jul-99", :unit_cost => 50.0, currency: "USD", category: "Book")
    assert_raise( ActiveRecord::RecordNotUnique ) { !MediaItem.create(:title=>"Refactoring",:author=>"Martin Fowler",:publisher=>"Addison Wesley",:published_on=>"8-Jul-99", :unit_cost => 50.0, currency: "USD", category: "Book") }
  end
  
  test "can import csv file" do
    MediaItem.import_csv
    assert_equal 4, MediaItem.count
    
    MediaItem.import_csv
    assert_equal 4, MediaItem.count

    # MediaItem.stubs(:CSV_FILE).returns(File.join( Rails.root.to_s, 'test', "fixtures", "media_items.csv"))
    # MediaItem.import_csv
    # assert_equal 4, MediaItem.count
  end
end
