class Api::V1::AreasController < ApplicationController
  #skip_before_action :verify_authenticity_token, :only => [:update]
  before_action :set_area, only: %i[ show update destroy ]

  # GET /areas
  def index
    puts "Params Limit: #{params[:_limit]}".magenta
    @areas = Area.all
    
    limit = params[:_limit]

    if limit.present?
      limit = limit.to_i
      @areas = @areas.last(limit).to_json({include: [:tasks]})
    end
    puts "@Areas: #{@areas.to_json({include: [:tasks]})}".cyan


    # puts "Area Description: #{@areas.first.description}".magenta
    render json: @areas.reverse.to_json({include: [:tasks]})
  end

  # GET /areas/1
  def show
    render json: @area
  end

  # POST /areas
  def create
    puts "Area Create: #{area_params}".magenta
    @area = Area.new(area_params)

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
      params.require(:area).permit(:id, :name, :description, :status, :_limit)
    end
end
