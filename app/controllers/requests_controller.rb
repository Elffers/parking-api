class RequestsController < ApplicationController
  before_action :set_request, only: [:show, :edit, :update, :destroy]
  # before_action :check_zoom, only: [:create]
  before_action :check_bounds, only: [:create]
  # before_action :find_request, only: [:create]

  def index
    @requests = Request.all
  end

  def show
  end

  def new
    @request = Request.new
  end

  def create
    @request = Request.new(request_params)
    @request.set_client(request.user_agent)
    @request.get_overlay
    if !@request.valid? # :coords, :bounds, :client
      respond_to do |format|
        format.html { redirect_to @request, notice: 'Bad request.', status: 400 }
        format.json { render json: @request, status: 400 }
      end
    else
      attributes = @request.attributes
      attributes.delete "_id"
      Resque.enqueue(SaveRequestJob, attributes)
      respond_to do |format|
        format.html { redirect_to @request, notice: 'Request was successfully created.' }
        format.json { render json: @request, status: 200 }
      end
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

  def check_bounds
    range = RangeChecker.new(params["request"])
    dragons = "https://s3-us-west-2.amazonaws.com/seattle-parking/dragons.png"
    unless range.validate
      respond_to do |format|
        format.html { render :index, notice: 'You are not in range.' }
        # render a custom JSON object with overlay.url attribute
        format.json { render json: dragons, status: 400 }
      end
    end
  end

  # def check_zoom
  # end
end
