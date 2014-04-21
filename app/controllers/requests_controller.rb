class RequestsController < ApplicationController
  before_action :set_request, only: [:show, :edit, :update, :destroy]
  before_action :check_bounds, only: [:create]
  # before_action :check_zoom, only: [:create]

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
    range = RangeChecker.new(params["request"]["bounds"])
    dragons = "https://s3-us-west-2.amazonaws.com/seattle-parking/dragons.png?AWSAccessKeyId=ASIAIO6GNGMN367KJSUQ&Expires=1398115345&Signature=57IUeXfVS5/B9aywwLYIFtxgd9Q%3D&x-amz-security-token=AQoDYXdzEPb//////////wEakAInAT47QMRyXMXPrnX5CBGI9GC4muYx07ZGwk5mk8WYR5itwl%2BFspCEZ6fRXXJCKwD%2BOdE26S%2BD6V1CAKSLdUgMHJJkeqE%2Bo4mcS4d1WFqc6AMVKI65uAyzboeCznrrg4jg5r4xhS1R3Et5IEwnRNt1QKiFD29MO5OIzU0iZBxgglicezpGlq52sXdva9uMHiMGwA8w66Zw%2BXwj9kh0l8eBmcb766P/LnrIWSirIbE4KRIYUEFOXrN6H6ml4xvHQ9K6/DFS1HCdAO/H4ax6M37LdgLoB%2BX/oF55CB4hwOr1Yc0BqvychwCC8MEntvgtP9syNeVpiPTvpwj8rJ9YCOjbeczoi8ZJ%2Bxe/7CaM5SxosSDJldaaBQ%3D%3D"
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
