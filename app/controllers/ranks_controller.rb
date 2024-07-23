# frozen_string_literal: true

class RanksController < ApplicationController
  before_action :cached_ranks

  def index
    if @cached_ranks
      @ranks = @cached_ranks

    else
      @ranks = Rank.all

      Rails.cache.write('ranks', @ranks, expires_in: 1.day)
    end
  end

  def show
    @cached_book_ranks = Rails.cache.read("book_ranks_#{params[:id]}")

    puts @cached_book_ranks
    if @cached_ranks && @cached_book_ranks
      @ranks = @cached_ranks
      @book_ranks = @cached_book_ranks

    else
      @ranks = Rank.all
      @book_ranks = BookRank.where(rank_id: params[:id]).order(order_id: :asc)

      Rails.cache.write('ranks', @ranks, expires_in: 1.day)
      Rails.cache.write("book_ranks_#{params[:id]}", @book_ranks, expires_in: 1.day)
    end
  end

  private

  def cached_ranks
    @cached_ranks = Rails.cache.read('ranks')
  end
end
