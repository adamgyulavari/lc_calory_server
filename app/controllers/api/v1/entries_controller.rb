class Api::V1::EntriesController < Api::V1::ApiController

  def index
    render json: wrapper(latest)
  end

  def create
    entry = Entry.new(entry_params)
    entry.user = current_user
    if @entry.save
      render json: wrapper(latest), status: 201
    else
      render json: { errors: entry.errors }, status: 422
    end
  end

  def update
    entry = Entry.find(params[:id])
    if entry.update_attributes entry_params
      render json: wrapper(latest), status: 200
    else
      render json: { errors: entry.errors }, status: 422
    end
  end

  def destroy
    Entry.find(params[:id]).destroy
    render json: wrapper(latest), status: 200
  end

  private

  def latest
    @entries = current_user.entries
    @entries = @entries.from_date(params[:from_date]) if params[:from_date] && !params[:from_date].nil?
    @entries = @entries.to_date(params[:to_date]) if params[:to_date] && !params[:to_date].nil?
    @entries = @entries.from_time(params[:from_time]) if params[:from_time] && params[:from_time] != "0"
    @entries = @entries.to_time(params[:to_time]) if params[:to_time] && params[:to_time] != "0"
    @entries = @entries.latest(10)
    @entries
  end

  def wrapper(array)
    { entries: array, entry_count: array.count }.to_json
  end

  def entry_params
    params.permit(:title, :num, :entry_date, :entry_time)
  end
end
