# frozen_string_literal: true

require "rails_helper"

describe Post::Operation::Create do
  subject(:result) { described_class.(params: params, current_user: current_user) }
  let(:current_user) do
    # user_result = User::Operation::Create.(params: { email: "janusz@o2.pl", name: "Janusz", password: "123456" })
    user_result = User::Admin::Operation::Create.(params: attributes_for(:user))
    raise "something went wrong" if user_result.failure?
    user_result[:model]
  end

  context "with valid params" do
    let(:params) { { title: "Introduction to Trailblazer operations", content: "pure awesomeness" } }

    it "creates a post" do
      expect { result }
        .to change { Post.count }
        .by(1)
      expect(result).to be_success
      expect(result[:model]).to be_present
      expect(result[:model].title).to eq("Introduction to Trailblazer operations")
      expect(result[:model].content).to eq("pure awesomeness")
      expect(result[:model].user).to eq(current_user)
    end

    context "with user not authorized" do
      let(:current_user) do
        user_result = User::Operation::Create.(params: attributes_for(:user))
        raise "something went wrong" if user_result.failure?
        user_result[:model]
      end

      it "policy fails" do
        expect { result }
          .not_to change { Post.count }
        expect(result).to be_failure
        expect(result["result.policy.default"]).to be_failure
      end
    end
  end

  context "with invalid params" do
    let(:params) { { title: "", content: "pure awesomeness" } }

    it "fails" do
      expect { result }
        .not_to change { Post.count }
      expect(result).to be_failure
      expect(result["result.contract.default"].errors[:title]).to be_present
    end
  end
end
