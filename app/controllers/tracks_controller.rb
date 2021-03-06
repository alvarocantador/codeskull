class TracksController < ApplicationController

  before_action :authenticate_user!
  before_action :set_track, only: [:show, :edit, :update, :export]
	
  layout 'dashboard'

  def index
    render(:index, layout: false, locals: {
	    tracks: Track.search(query).records,
	  })
  end

  def new
    render(:new, locals: {
      track: Track.new
    })
  end

  def create  
    @track = Track.new(track_params)
    @track.users << current_user
    if @track.save
      params[:attachments]&.each { |attachment|
          @track.contents.create(file: attachment)
      }
      redirect_to '/' # should redirect to create new tasks
    end
  end

  def show
    render(:show, locals: {
      track: @track
    })
  end

  def edit
    render(:edit, locals: {
      track: @track
    })
  end

  def update
    if @track.update(track_params)
      params[:attachments]&.each { |attachment|
        @track.contents.create(file: attachment)
      }
      redirect_to track_url(@track)
    end
  end

  def export
    render(:export, layout: false, locals: {
      track: @track
    })
  end

  private

    def set_track
    	@track = Track.includes(:contents).find(params[:id])
      authorize @track
    end

    def track_params
    	params.require(:track).permit(:title, :description, :language, :idiom)
    end

    def search_params
      params.permit(:q)
    end

    def query
      "*#{search_params[:q]}*"
    end
	
end
