# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Review, type: :model do
  describe 'Valid factory' do
    subject(:factory) { build(:review) }
    it { is_expected.to be_valid }
  end

  describe 'Validation presence check' do
    it { is_expected.to validate_presence_of(:comment) }
    it { is_expected.to validate_numericality_of(:star).is_in(0..5) }
  end

  describe 'Association' do
    it { is_expected.to belong_to(:book) }
  end
end
