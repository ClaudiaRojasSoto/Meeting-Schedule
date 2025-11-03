class ScheduleItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_meeting
  before_action :set_item, only: [:update, :destroy]

  def create
    @item = @meeting.schedule_items.build(item_params)
    @item.position ||= (@meeting.schedule_items.maximum(:position) || 0) + 1
    
    if @item.save
      redirect_to @meeting, notice: "Item agregado exitosamente."
    else
      redirect_to @meeting, alert: "Error al agregar item."
    end
  end

  def update
    if @item.update(item_params)
      redirect_to @meeting, notice: "Item actualizado exitosamente."
    else
      redirect_to @meeting, alert: "Error al actualizar item."
    end
  end

  def destroy
    @item.destroy
    redirect_to @meeting, notice: "Item eliminado exitosamente."
  end

  def reorder
    params[:order].each_with_index do |id, index|
      item = @meeting.schedule_items.find(id)
      item.update(position: index + 1)
    end
    head :ok
  end

  private

  def set_meeting
    @meeting = Meeting.find(params[:meeting_id])
  end

  def set_item
    @item = @meeting.schedule_items.find(params[:id])
  end

  def item_params
    params.require(:schedule_item).permit(:start_time, :duration_minutes, :role, :speaker, :notes, :position)
  end
end
