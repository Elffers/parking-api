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
    # p "REQUEST", request.user_agent
    @request.set_client(request.user_agent)
    @request.get_overlay
    request_params = @request.as_json
    # p request.user_agent
    if !@request.valid?
      respond_to do |format|
        format.html { redirect_to @request, notice: 'Bad request.', status: 400 }
        format.json { render json: @request, status: 400 }
      end
    elsif @request.overlay
      Resque.enqueue(SaveRequestJob, request_params)

      respond_to do |format|
        #put off saving until later (it will be a background job). get rid of conditional and still return overlay
        format.html { redirect_to @request, notice: 'Request was successfully created.' }
        format.json { render json: @request, status: 200 }
      end
    else
      # ERROR
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
      # TODO: check bounds
      bbox = params["request"]["bounds"]
      bounds = bbox.delete("()").split(/\s*,\s*/)
      # if bounds[1], bounds[3] && bounds[0], bounds[2] are within range
      # else
      # end
    end
end
