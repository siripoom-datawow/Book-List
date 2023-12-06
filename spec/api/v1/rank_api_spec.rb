# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::ReviewAPI do
  let!(:user)  {create(:user)}

  describe 'Get all ranks' do
    subject { get "/api/v1/rank" , headers: { 'authorization' => "Bearer: #{user.auth_token}" } }

    let!(:rank_a) {create(:rank)}
    let!(:rank_b) {create(:rank)}


    it 'responds with 200 and retuen all ranks'  do
      subject
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq([rank_a.as_json, rank_b.as_json])
    end

    after do
      Rails.cache.clear
    end
  end

  describe 'Get single ranks' do
    subject { get "/api/v1/rank" , headers: { 'authorization' => "Bearer: #{user.auth_token}" } }

    let!(:rank) {create(:rank)}


    it 'responds with 200 and single rank'  do
      subject
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq([rank.as_json])
    end

    after do
      Rails.cache.clear
    end
  end
end
