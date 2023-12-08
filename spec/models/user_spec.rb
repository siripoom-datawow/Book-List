# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Valid factory' do
    subject(:factory) { build(:user) }
    it { is_expected.to be_valid }
  end
end
