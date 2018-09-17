# frozen_string_literal: true

require "rails_helper"

describe User::Operation::Create do
  subject(:result) { described_class.(params: params) }

  context "with valid params" do
    let(:params) { { name: "Andrzej", email: "andrzej@o2.pl", password: "secret" } }

    it "creates an user" do
      expect { result }
        .to change { User.count }
        .by(1)
      expect(result).to be_success
      expect(result[:model]).to be_present
      expect(result[:model].name).to eq("Andrzej")
      expect(result[:model].email).to eq("andrzej@o2.pl")
    end
  end

  context "with invalid params" do
    let(:params) { { name: "", email: "andrzej@o2.pl", password: "secret" } }

    it "fails" do
      expect { result }
        .not_to change { User.count }
      expect(result).to be_failure
      expect(result["result.contract.default"].errors[:name]).to be_present
    end
  end
end
