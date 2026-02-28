module Paginatable
  extend ActiveSupport::Concern

  class_methods do
    def page(page_number, per_page: 25)
      page_number = [page_number.to_i, 1].max
      offset((page_number - 1) * per_page).limit(per_page)
    end
  end
end
