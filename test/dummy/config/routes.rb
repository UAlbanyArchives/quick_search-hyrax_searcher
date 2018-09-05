Rails.application.routes.draw do
  mount QuickSearch::Hyrax::Engine => "/quick_search-hyrax"
end
