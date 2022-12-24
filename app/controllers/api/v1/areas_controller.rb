class Api::V1::AreasController < ApplicationController
  #skip_before_action :verify_authenticity_token, :only => [:update]
  before_action :set_area, only: %i[ show update destroy ]

  # GET /areas
  def index 
    if params[:_dueFilter].present?
      dueBy = params[:_dueFilter].to_str()
      @work_areas = Area.where("frequency <= ? ", dueBy).order(frequency: "asc")
    elsif params[:_limit].present?
      limit = params[:_limit].to_i
      @work_areas = Area.order(frequency: "asc").last(limit) 
    elsif params[:_pastDue].present?
      @work_areas = Area.order(frequency: "asc") #.last(limit) 
      arr = Array.new
      @work_areas.each do |area|
        if area.action_date
          if area.action_date+ area.frequency.days < Date.today
            arr << area
          end
        end
      end   
      @work_areas = arr  #Area.order(frequency: "asc").last(limit) 
    else
      @work_areas = Area.order(frequency: "asc")
    end
    @areas = @work_areas
    render json: @areas.to_json({include: [:histories]})
  end

  # GET /areas/1
  def show
    render json: @areas.to_json({include: [:histories]})
  end

  # POST /areas
  def create
    @area = Area.new(area_params)
    @area.action_date = Date.today.strftime("%m-%d-%y")
    if @area.save
      @area.histories.new(
        notes: "Area created for #{@area.description}",
        status: 'new').save!
      #render json: @area, status: :created, location: 'api/vi/areas/path(@area)'
      render json: @areas.to_json({include: [:histories]}),  status: :created
    else
      render json: @area.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /areas/1
  def update
    if @area.update(area_params)

      @history = @area.histories.new
      if @area.completed == true
        @history.notes = "Last completed"
        @history.status = 'completed'
        @history.save!      
        ##NotificationMailer.with(area: @area).notification_email_view.deliver
      else       
        @history.notes = "Last opened"
        @history.status = 'active'
        @history.save!      
        ##NotificationMailer.with(area: @area).notification_email_view.deliver
      end
      #render json: @area
      render json: @area.to_json({include: [:histories]}),  status: :created
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
                                   :action_date,
                                   :notes,
                                   :_limit,
                                   :_dueFilter,
                                   :pastDue)
    end
    def history_params
      if params[:histories]
        params.require(:histories).map do |history|
          history.permit(:name,
                     :area_id,
                     :name,
                     :description,
                     :assigned_to,
                     :assigned_to_email,
                     :status,
                     :notes)
        end
      end
    end       
end
