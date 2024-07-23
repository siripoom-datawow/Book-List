# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization

  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid
  rescue_from ActiveRecord::RecordNotSaved, with: :handle_record_not_saved
  rescue_from Pundit::NotAuthorizedError, with: :handle_unauthorized

  private

  def handle_record_not_found
    respond_to do |format|
      format.html do
        flash[:alert] = 'No data found'
        redirect_back(fallback_location: root_path)
      end
      format.json { render json: { error: 'Data not found' }, status: :not_found }
    end
  end

  def handle_record_invalid(error)
    respond_to do |format|
      format.html do
        flash[:alert] = error.message
        redirect_back(fallback_location: root_path)
      end
      format.json { render json: { error: error.message }, status: :unprocessable_entity }
    end
  end

  def handle_record_not_saved(error)
    respond_to do |format|
      format.html do
        flash[:alert] = "Failed to save record #{error.message}"
        redirect_back(fallback_location: root_path)
      end
      format.json { render json: { error: "Failed to save record #{error.message}" }, status: :unprocessable_entity }
    end
  end

  def handle_unauthorized(_error)
    respond_to do |format|
      format.html do
        flash[:alert] = 'User ubauthorized'
        redirect_back(fallback_location: root_path)
      end
      format.json { render json: { error: 'User unauthorized' }, status: :forbidden }
    end
  end
end
