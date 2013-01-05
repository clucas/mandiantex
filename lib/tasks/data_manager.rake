namespace :app do
  desc "Cache search suggestions"
  task :cache_suggestions => :environment do
    SearchSuggestion.index_items
  end

  desc "Import items CSV"
  task :import_csv => :environment do
    MediaItem.import_csv
  end

  desc "Index data for search"
  task :index_search => :environment do
    system "rake environment tire:import CLASS='MediaItem' FORCE=true"
  end
  
  desc "Import data and re-ndex"
  task :import_and_index => [:import_csv, :cache_suggestions, :index_search] do
  end
end
