class EventsController < ApplicationController
  layout "site"
  before_action :authorize_web
  before_action :set_event, :only => [:edit, :show, :update]

  authorize_resource

  # GET /events
  # GET /events.json
  def index
    @events = Event.all
  end

  # GET /events/new
  def new
    @title = t "events.new.title"
    @event = Event.new
    @event.microcosm_id = params[:microcosm_id]
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    @event_organizer = EventOrganizer.new(:event => @event, :user => current_user)

    if @event.save && @event_organizer.save
      redirect_to @event, :notice => t(".success")
    else
      flash[:alert] = t(".failure")
      render :new
    end
  end

  # GET /events/1/edit
  def edit; end

  def update
    if @event.update(event_params)
      redirect_to @event, :notice => t(".success")
    else
      flash[:alert] = t(".failure")
      render :edit
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @my_attendance = EventAttendance.find_or_initialize_by(:event_id => @event.id, :user_id => current_user&.id)
    @yes_check = @my_attendance.intention == "Yes" ? "✓" : ""
    @no_check = @my_attendance.intention == "No" ? "✓" : ""
    @yes_disabled = @my_attendance.intention == "Yes"
    @no_disabled = @my_attendance.intention == "No"
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    nilify(params.require(:event).permit(:title, :moment, :location, :location_url,
                                         :description, :latitude, :longitude, :microcosm_id))
  end
end
