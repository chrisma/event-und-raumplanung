class RoomsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_room, only: [:show, :edit, :update, :destroy, :details, :list_events]
  before_action :set_all_properties, only: [:edit, :new]
  before_action :set_equipment, only: [:edit, :new, :update, :create]

  # GET /rooms
  # GET /rooms.json
  def index
    @filterrific = Filterrific.new(Room,params[:filterrific] || session[:filterrific_rooms])
    @filterrific.select_options =  {sorted_by: Room.options_for_sorted_by, items_per_page: Room.options_for_per_page}
    @rooms = Room.filterrific_find(@filterrific).page(params[:page]).per_page(@filterrific.items_per_page || Room.per_page)
    session[:filterrific_rooms] = @filterrific.to_hash

    respond_to do |format|
      format.html
      format.js
    end
  end

  def reset_filterrific
    # Clear session persistence
    session[:filterrific_rooms] = nil
    # Redirect back to the index action for default filter settings.
    redirect_to action: :index
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
    @events = @room.upcoming_events.take(5)
    @assigned_equipment = Equipment.all.where(room_id: @room.id).group(:category).count
  end

  # GET /rooms/new
  def new
    @room = Room.new
    authorize! :new, @room
  end

  def list
    @categories = Equipment.group(:category).pluck(:category)
    @properties = RoomProperty.group(:name).pluck(:name)
    @empty = false;
    @noSelection = false
    rooms_ids = Room.all.pluck(:id)
    if params.size <= 4
        if params[:room].nil? or params[:room][:size].empty?
            @noSelection = true
        end
    end
    if !params[:room].nil? and !params[:room][:size].empty?
      @size = params[:room][:size]
      rooms_ids = rooms_ids & Room.where('size >= ?', @size).pluck(:id)
     end
     @categories.each do |category|
      if params.has_key?(category)
    rooms_ids = rooms_ids & Equipment.where(:category => category).pluck(:room_id)
      end
     end
     @properties.each do |name|
         if params.has_key?(name)
             rooms_ids = rooms_ids & RoomProperty.where(:name => name).pluck(:room_id)
         end
     end
     if rooms_ids.empty?
       @empty = true
     end
     @rooms = Room.find(rooms_ids)
  end

  def get_valid_rooms
    needed_rooms = []
    if params['room']['equipment']
      needed_rooms = get_valid_rooms_for_equipment(params['room']['equipment'])
    end
    if params['room']['size']
      needed_rooms = get_valid_rooms_for_size(needed_rooms, params['room']['size'].to_i)
    end
    if !params['room']['equipment'] && !params['room']['size']
      needed_rooms = Room.all
    end
    msg = needed_rooms.map { |room|  {"id" => room.id, "name" => room.name}}
    respond_to do |format|
        format.json { render :json => msg} 
    end 
  end 

  # GET /rooms/1/edit
  def edit
    authorize! :edit, @room
  end

  # GET /rooms/1/events
  def list_events
    @events = @room.upcoming_events
    render 'events'
  end

  # POST /rooms
  # POST /rooms.json
  def create
    @room = Room.new(room_params)
    #authorize! :create, @room
    respond_to do |format|
      if @room.save
        assign_equipment
        format.html { redirect_to rooms_path, notice: t('notices.successful_create', :model => Room.model_name.human) }
        format.json { render :show, status: :created, location: @room }
      else
        format.html { render :new }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rooms/1
  # PATCH/PUT /rooms/1.json
  def update
    assign_equipment
    #authorize! :update, @room

    respond_to do |format|
      if @room.update(room_params)
        format.html { redirect_to rooms_path, notice: t('notices.successful_update', :model => Room.model_name.human) }
        format.json { render :show, status: :ok, location: @room }
      else
        format.html { render :edit }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    #authorize! :destroy, @room
    free_equipment    
    @room.destroy
    respond_to do |format|
      format.html { redirect_to rooms_url, notice: t('notices.successful_destroy', :model => Room.model_name.human) }
      format.json { head :no_content }
    end
  end

  def printoverview
    @rooms = Room.all
    render locals: {rooms:@rooms}
  end



  def print
    set_room
    render_print_rooms([@room.id])
  end

  def print_rooms
    throw "need room ids" unless params[:rooms]
    room_ids = params[:rooms].split(',')
    render_print_rooms(room_ids)
  end

  def render_print_rooms(room_ids)   
    date = params[:date] ? Date.parse(params[:date]) :  Date.today.monday
    week = date.cweek
    year = date.cwyear
    @weekBegin = date
    @prints = []
    room_ids.each do | room_id |
        @calevents = []
        room = Room.find(room_id)
        events = Event.approved.room_ids([room_id])
        events.each do |event|
          if(event.schedule)
            occurrences = event.schedule.occurrences_between(date.monday,date.sunday) || []
            occurrences.each do |occurrence|
              @calevents << Event.new(name:event.name, starts_at:occurrence.start_time, ends_at:occurrence.end_time, is_private:event.is_private)
            end
          else
            @calevents << event if event.in_week(week, year)
          end
        end
        @prints << {room:room, events:@calevents, lang: I18n.locale, weekBegin: @weekBegin } if room
    end
    render action: 'print', layout:'print', locals:{ prints: @prints}
  end

  def fetch_event
    if Event.exists?(params[:id])
      event = Event.find(params[:id])
      rooms = event.rooms.map(&:name).to_sentence
      if event.starts_at
        startTime = event.starts_at.strftime("%d.%m.%Y - %H:%M")
      else
        startTime = ''
      end
      if event.ends_at
        endTime = event.ends_at.strftime("%d.%m.%Y - %H:%M")
      else
        endTime = ''
      end
      user = User.find(event.user_id).identity_url
      declinePath = decline_event_suggestion_event_path(event)
      approvePath = approve_event_suggestion_event_path(event)
      render json: {success: true, body: {event: event, rooms: rooms, startTime: startTime, endTime: endTime, 
                      user: user, approvePath: approvePath, declinePath: declinePath}}
    else
      render json: {success: false}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    def set_all_properties
      @properties = RoomProperty.all
    end
    
    def set_equipment
      if @room
        @available_equipment = Equipment.all.where("room_id IS ? or room_id = '?'", 
          nil, @room.id).group(:category).count
        @assigned_equipment = Equipment.all.where(room_id: @room.id).group(:category).count
      else
        @available_equipment = Equipment.all.where("room_id IS ?", nil).group(:category).count
        @assigned_equipment = {}
      end
    end

    def assign_equipment
      @available_equipment.each do |category, count|
        key = category+'_equipment_count'
        count = params[key]
        if @assigned_equipment[category] != nil
          count = count.to_i - @assigned_equipment[category]
        else
          count = count.to_i
        end
        if count>0 
          for number in 1..count do
            new_equipment = Equipment.where('room_id IS ? and category=?', nil, category).first
            new_equipment.room_id = @room.id
            new_equipment.save
          end
        elsif count<0
          for number in count..-1 do
            new_equipment = Equipment.where('room_id=? and category=?', @room.id, category).first
            new_equipment.room_id = nil
            new_equipment.save
          end
        end
      end
    end
    
    def free_equipment
      @room.equipment.each do |equipment|
        equipment.room_id = nil
        equipment.save
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      params.require(:room).permit(:name, :size, :property_ids => [])
    end

    def get_valid_rooms_for_equipment needed_equipment
      needed_equipment = Equipment.where("category IN (?)", params['room']['equipment'])
      needed_rooms = needed_equipment.collect { |equipment| equipment.room }
      h = Hash.new(0)
      needed_rooms.each { |room| h.store(room, h[room]+1) }
      needed_rooms.to_a.keep_if { |room| h[room] == params['room']['equipment'].size}
      return needed_rooms
    end
    
    def get_valid_rooms_for_size filtered_rooms, size
      if filtered_rooms.empty? 
        filtered_rooms = Room.where("size >= :room_size", {:room_size => size})
      else
        filtered_rooms.to_a.keep_if {|room| room.size >= size}
      end
      return filtered_rooms
    end
end
