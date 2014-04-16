class RequestsController < ApplicationController
  before_action :set_request, only: [:show, :edit, :update, :destroy]
  # before_action :check_bounds, only: [:create]

  def index
    @requests = Request.all
  end

  def show
  end

  def new
    @request = Request.new
  end

  def edit
  end

  def create
    @request = Request.new(request_params)
    @request.set_client(request.user_agent)
    @request.get_overlay
    if !@request.valid?
      respond_to do |format|
        format.html { redirect_to @request, notice: 'Bad request.', status: 400 }
        format.json { render json: @request, status: 400 }
      end
    elsif @request.overlay
      @request.save
      # Resque.enqueue(SaveRequestJob, request_params)
      respond_to do |format|
        format.html { redirect_to @request, notice: 'Request was successfully created.' }
        format.json { render json: @request, status: 200 }
      end
    else
      respond_to do |format|
        format.json { render json: "NOOOOOPE", status: 404 }
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
      # bbox = params["request"]["bounds"]
      bbox = "((47.62166982344883, -122.31682166721191), (47.624562336539235, -122.31253013278808))"
      bounds = bbox.delete("()").split(/\s*,\s*/)
      longs = [bounds[1], bounds[3]]
      lats = [bounds[0], bounds[2]]
      puts "LATS", lats, "LONGS", longs
      # if bounds[1], bounds[3] && bounds[0], bounds[2] are within range
      # else
      # end
    end
end
