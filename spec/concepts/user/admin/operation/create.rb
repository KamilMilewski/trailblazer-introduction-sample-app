# frozen_string_literal: true

require "rails_helper"

describe User::Admin::Operation::Create do
  subject(:result) { described_class.(params: params) }

  context "with valid params" do
    let(:params) { { name: "Andrzej", email: "andrzej@o2.pl", password: "secret" } }

    it "creates an admin" do
      expect { result }
        .to change { User.count }
        .by(1)
      expect(result[:model].admin).to eq(true)
      expect(result).to be_success
    end
  end
end
