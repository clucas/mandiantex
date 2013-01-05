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

require 'csv'
require 'iconv'

class MediaItem < ActiveRecord::Base
  attr_accessible :author, :category, :currency, :published_on, :publisher, :title, :unit_cost, :price
  
  include Tire::Model::Search
  include Tire::Model::Callbacks  

  MARKUP = YAML.load_file("#{Rails.root}/config/markup.yml")
  CSV_FILE = File.join( Rails.root.to_s, 'db', "import", "media_items.csv")
  
  composed_of :unit_cost,
              :class_name => 'Money',
              :mapping => [%w(unit_cost fractional), %w(currency currency_as_string)],
              :constructor => Proc.new { |unit_cost, currency| Money.new(unit_cost, currency || Money.default_currency) },
              :converter => Proc.new { |value| value.respond_to?(:to_money) ? (value.to_f.to_money rescue Money.empty) : Money.empty }
  
  validates :title, :presence => {:message => 'cannot be blank'}
  validates :author, :presence => {:message => 'cannot be blank'}
  validates :publisher, :presence => {:message => 'cannot be blank'}
  validates :category, :presence => {:message => 'cannot be blank'}
  validates :published_on, :presence => true
  
  
  mapping do
    indexes :id, :index => :not_analyzed
    indexes :currency, :index => :not_analyzed
    indexes :unit_cost, :index => :not_analyzed
    indexes :published_on, :index => :not_analyzed
    indexes :title, :type => 'multi_field', :fields => { :title =>  { :type => 'string', :analyzer => 'snowball' },
                                                         :exact => { :type => 'string', :index => 'not_analyzed' } }
    indexes :author, :type => 'multi_field', :fields => { :author =>  { :type => 'string', :analyzer => 'snowball' },
                                                        :exact => { :type => 'string', :index => 'not_analyzed' } }
    indexes :price, :type => 'multi_field', :fields => { :price =>  { :type => 'float', :analyzer => 'keyword' },
                                                        :exact => { :type => 'float', :index => 'not_analyzed' } }
    indexes :category, :analyzer => 'keyword'
    indexes :publisher, :analyzer => 'snowball'
  end  
  
  def self.search(params)
    tire.search(load: true, page: params[:page], per_page: 10) do
      if params[:query].present?
        query { string params[:query], default_operator: "AND" }
      else
        query { all }
      end
      
      sort { by "title.exact", params[:sort][:title]} if params[:sort].present? && !params[:sort][:title].blank?
      sort { by "author.exact", params[:sort][:author]} if params[:sort].present? && !params[:sort][:author].blank?
      sort { by "price.exact", params[:sort][:price]} if params[:sort].present? && !params[:sort][:price].blank?
    end
  end
  
  
  def price
    unit_cost.to_d * ( 1 + MARKUP[self.category] )
  end
  
  def display_price
    price.to_s
  end
  
  def to_indexed_json
    to_json(methods: [:display_price, :price])
  end
  
  def self.import_csv
    begin
      CSV.foreach(MediaItem::CSV_FILE, {:headers => true, :header_converters => :symbol}) do |row|
        media_item = MediaItem.find_by_title_and_author_and_publisher_and_published_on(row[:title], row[:author], row[:publisher], row[:published_on]) || MediaItem.new
        media_item.attributes = row.to_hash.merge({:currency => "USD"})
        media_item.unit_cost = row[:unit_cost].to_f * 100.0
        media_item.save!
      end
    rescue Exception => e
      puts e.message
      puts "Media item could not be created for row: #{row.to_hash}" if row
    end
  end
end
