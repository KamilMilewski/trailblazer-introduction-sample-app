class Post < ApplicationRecord
  module Contract
    class Create < Reform::Form
      property :title
      property :content
      property :user_id

      validation do
        required(:title).filled(:str?)
        required(:content).filled(:str?)
      end

    end
  end
end
