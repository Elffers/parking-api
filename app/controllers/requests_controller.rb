class RequestsController < ApplicationController
  before_action :set_request, only: [:show, :edit, :update, :destroy]

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
    p "BEFORE", request_params
    @request.set_client(request.user_agent)
    @request.get_overlay
    request_params = @request.as_json
    p "ENQUE", request_params
    Resque.enqueue(SaveRequestJob, request_params)
    respond_to do |format|
      #put off saving until later (it will be a background job). get rid of conditional and still return overlay
      if true
        format.html { redirect_to @request, notice: 'Request was successfully created.' }
        format.json { render json: @request, status: 200 }
      else
        # format.html { render action: 'new' }
        format.json { render json: @request.errors, status: :unprocessable_entity }
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
end
