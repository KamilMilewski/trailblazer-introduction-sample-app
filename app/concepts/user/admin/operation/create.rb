class User < ApplicationRecord
  module Admin
    module Operation
      class Create < Trailblazer::Operation
        step Nested(::User::Operation::Create)
        step :set_admin_flag

        def set_admin_flag(ctx, **)
          ctx[:model].update(admin: true)
        end
      end
    end
  end
end
