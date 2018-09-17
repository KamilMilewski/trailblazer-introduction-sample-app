class User < ApplicationRecord
  module Contract
    class Create < Reform::Form
      property :name
      property :email
      property :password

      validation do
        required(:name).filled(:str?)
        required(:email).filled(:str?)
        required(:password) { str? & min_size?(6) }
      end

    end
  end
end
