class Api::V1::AreasController < ApplicationController
  #skip_before_action :verify_authenticity_token, :only => [:update]
  before_action :set_area, only: %i[ show update destroy ]

  # GET /areas
  def index 
    if params[:_dueFilter].present?
      dueBy = params[:_dueFilter].to_str()
      @work_areas = Area.where("frequency <= ? ", dueBy)
    elsif params[:_limit].present?
      limit = params[:_limit].to_i
      @work_areas = Area.order(frequency: "asc").last(limit) 
    elsif params[:_pastDue].present?
      @work_areas = Area.order(frequency: "asc") #.last(limit) 
      # Date Today - date_completed > frequency
      # date_completed + frequency > Date.today
      # duration = (Date.today - date_completed).to_i
      # where date_completed + frequency
      arr = Array.new
      @work_areas.each do |area|
        if area.date_completed
          if area.date_completed+ area.frequency.days < Date.today
            puts "Hit - Frequency: #{area.frequency} Days - Date Completed: #{area.date_completed} - Date Due: #{area.date_completed + area.frequency.days} Today: #{Date.today} Under By #{((area.date_completed + area.frequency.days) - Date.today).to_i * -1} days".red
            arr << area
          else
            puts "Miss - Frequency: #{area.frequency} Days - Date Completed: #{area.date_completed} - Date Due: #{area.date_completed + area.frequency.days} Today: #{Date.today} Over By #{((area.date_completed + area.frequency.days) - Date.today).to_i} days".cyan
          end
        end
      end
      @work_areas = arr  #Area.order(frequency: "asc").last(limit) 
    else
      @work_areas = Area.order(frequency: "asc")
    end
    @areas = @work_areas
    render json: @areas.to_json
  end

  # GET /areas/1
  def show
    render json: @area
  end

  # POST /areas
  def create
    @area = Area.new(area_params)
    @area.date_completed = Date.today
    if @area.save
      render json: @area, status: :created, location: 'api/vi/areas/path(@area)'
    else
      render json: @area.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /areas/1
  def update
    if @area.update(area_params)
      ##NotificationMailer.with(area: @area).notification_email_view.deliver
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
      params.require(:area).permit(:id,
                                   :name, 
                                   :description,
                                   :frequency, 
                                   :completed, 
                                   :date_completed,
                                   :notes,
                                   :_limit,
                                   :_dueFilter,
                                   :pastDue)
    end
end
