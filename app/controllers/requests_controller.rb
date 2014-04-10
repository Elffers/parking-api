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
    @request.set_client(request.user_agent)
    @request.get_overlay
    respond_to do |format|
      if @request.save
        # format.html { redirect_to @request, notice: 'Request was successfully created.' }
        format.json { render json: @request.overlay, status: 200 }
      else
        format.html { render action: 'new' }
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
