class User < ApplicationRecord
  module Operation
    class Create < Trailblazer::Operation
      # step Model(User)
      # step self::Contract::Build(constant: User::Contract::Create)
      # step self::Contract::Validate()
      # step self::Contract::Persist(method: :save)

      step :model
      step :build_contract
      step :validate
      fail ->(ctx, **) { ctx["error"] = "Validation failed" }
      fail ->(ctx, **) { ctx["error"] = "Did I mentioned that validation failed?" }, fail_fast: true
      fail ->(ctx, **) { ctx["error"] = "This line won't be executed because previous failure step has 'fail_fast' option" }
      step :persist
      step :send_welcoming_email

      def model(ctx, **)
        ctx[:model] = User.new
      end

      def build_contract(ctx, model:, **)
        ctx["result.contract.default"] = User::Contract::Create.new(model)
      end

      def validate(ctx, params:, **)
        ctx["result.contract.default"].validate(params)
      end

      def persist(ctx, model:, **)
        ctx["result.contract.default"].save
      end

      def send_welcoming_email(ctx, model:, **)
        UserMailer.with(user: model).welcome_email.deliver_now
      end
    end
  end
end
