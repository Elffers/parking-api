class RequestsController < ApplicationController
  before_action :set_request, only: [:show, :destroy]

  def index
    @requests = Request.all
  end

  def show
  end

  def new
    @request = Request.new
  end

  def create
    # Request.find_or_initialize_by? or before action to find request
    @request = Request.new(request_params)
    @request.set_client(request.user_agent) unless @request.client
    @request.get_overlay
    if !@request.valid?
      respond_to do |format|
        format.html { redirect_to @request, notice: 'Bad request.', status: 400 }
        format.json { render json: @request, status: 400 }
      end
    elsif @request.in_seattle? && @request.zoomed?
      @request.queue_save
      respond_to do |format|
        format.html { redirect_to @request, notice: 'Request was successfully created.' }
        format.json { render json: @request, status: 200 }
      end
    elsif @request.in_seattle? && !@request.zoomed?
      ladies = @request.get_ladies
      error_response("Zoom in plz", ladies, 400)
    elsif !@request.in_seattle?
      dragons = @request.get_dragons
      error_response('Here be dragons', dragons, 418)
    else # unknown errors
      error_response('PORBLEMS', 'PORBLEMS', 400)
    end
  end

  def destroy
    @request.destroy
    respond_to do |format|
      format.html { redirect_to requests_url }
      format.json { head :no_content }
    end
  end

  private
  def set_request
    @request = Request.find(params[:id])
  end

  def request_params
    params.require(:request).permit(:coords, :bounds, :size, :client, :version, :overlay)
  end

  def error_response(notice, json, status)
    respond_to do |format|
      format.html { render :index, notice: notice }
      format.json { render json: json, status: status }
    end
  end
end
