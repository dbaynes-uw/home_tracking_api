class Api::V1::AreasController < ApplicationController
  #skip_before_action :verify_authenticity_token, :only => [:update]
  before_action :set_area, only: %i[ show update destroy ]

  # GET /areas
  def index 
    if params[:_dueFilter].present?
      dueBy = params[:_dueFilter].to_str()
      @areas = Area.where("frequency <= ? ", dueBy)
    elsif params[:_limit].present?
      limit = params[:_limit].to_i
      @areas = Area.order(frequency: "asc").last(limit) 
    else
      @areas = Area.order(frequency: "asc")
    end
    render json: @areas.to_json({include: [:tasks]})
  end

  # GET /areas/1
  def show
    render json: @area
  end

  # POST /areas
  def create
    @area = Area.new(area_params)

    if @area.save
      @area.tasks.create(task_params)
    end
    if @area.save
      render json: @area, status: :created, location: 'api/vi/areas/path(@area)'
    else
      render json: @area.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /areas/1
  def update
    if @area.update(area_params)
      render json: @area
    else
      render json: @area.errors, status: :unprocessable_entity
    end
  end

  # DELETE /areas/1
  def destroy
    @area.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_area
      @area = Area.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def area_params
      puts "Params: #{params}".magenta
      params.require(:area).permit(:id, :name, :description, :frequency, :completed, :_limit, :_dueFilter)
    end
    def task_params
      unless params[:tasks].empty?
        params.require(:tasks).map do |task|
          task.permit(:name,
                      :description,
                     :fee_or_balance,
                     :assigned_to,
                     :assigned_to_email,
                     :notes)
        end
      end
    end    
end
