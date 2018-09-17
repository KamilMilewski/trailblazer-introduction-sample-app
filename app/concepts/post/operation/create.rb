class Post < ApplicationRecord
  module Operation
    class Create < Trailblazer::Operation
      step :model
      step Policy::Pundit(PostPolicy, :create?)
      fail ->(ctx, **) { ctx["error"] = "Not authorized" }, fail_fast: true
      step :build_contract
      step self::Contract::Validate()
      fail ->(ctx, **) { ctx["error"] = "Validation failed" }, fail_fast: true
      step self::Contract::Persist(method: :save)
      fail ->(ctx, **) { ctx["error"] = "Failed to save post" }, fail_fast: true

      def model(ctx, current_user:, **)
        ctx[:model] = current_user.posts.new
      end

      def build_contract(ctx, model:, current_user:, **)
        ctx["contract.default"] = Post::Contract::Create.new(model)
      end
    end
  end
end
