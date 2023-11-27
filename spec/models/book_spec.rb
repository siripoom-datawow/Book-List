# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'Valid factory' do
    subject(:factory) { build(:book) }
    it { is_expected.to be_valid }
  end

  describe 'Validation presence check' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:release) }
  end

  describe 'Association' do
    it { is_expected.to have_many(:reviews) }
  end

  describe '#all__reviews_comment' do
    subject { book_a.all__reviews_comment }

    let(:book_a) { create(:book) }
    let(:book_b) { create(:book) }
    let(:review_a) { create(:review, comment: 'awdwegk', star: 1.0, book: book_a) }
    let(:review_b) { create(:review, comment: 'aawd234awdk', star: 2.0, book: book_a) }
    let(:review_c) { create(:review, comment: 'a23k', star: 1.0, book: book_b) }

    before do
      review_a
      review_b
      review_c
    end

    it 'return all review comment' do
      is_expected.to eq("#{review_a.comment}, #{review_b.comment}")
    end
  end

  describe 'Get average star when present' do
    subject {book_a.get_avg_star}
    let(:book_a) {create(:book)}
    it "return No star" do
      expect(subject).to eq('No review')
    end

    let(:review_a) {create(:review)}
    let(:review_b) {create(:review)}
    let(:review_c) {create(:review)}
    it "return correct average" do
      expect(subject).to eq(Book.find(book_a.id).get_avg_star)
    end
  end
end
