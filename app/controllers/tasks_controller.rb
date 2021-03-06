class TasksController < ApplicationController
	
  	before_action :authenticate_user!
  	before_action :set_track
  	before_action :set_task, only: [:destroy, :show, :edit, :update]
	
	layout 'dashboard'
	
	def index
		render(:index, locals: {
	      track: @track
	    })
	end

	def new
		render(:new, locals: {
	      track: @track,
	      task: Task.new(track: @track)
	    })
	end

	def create
		@task = Task.new(task_params)
		@task.track = @track
		@task.save!
		redirect_to track_tasks_path(@track)
	end

	def destroy
		@task.destroy
		redirect_to track_tasks_path(@track)
	end

	def show
		render(:show, locals: {
	      track: @track,
	      task: @task
	    })
	end

	def edit
		render(:edit, locals: {
	      track: @track,
	      task: @task
	    })
	end

	def update
		if @task.update(task_params)
			redirect_to track_tasks_path(@track)
		end
	end


	private

		def set_track
			@track = Track.find(params[:track_id])
			# authorize @track
		end

		def set_task
			@task = Task.find(params[:id])
			# authorize @task
		end

		def task_params
			params.require(:task).permit(:category, :title, :content, :snippet, 
				:expectations_attributes => [ :name, :type, :value, :operator] )
		end
		
end
