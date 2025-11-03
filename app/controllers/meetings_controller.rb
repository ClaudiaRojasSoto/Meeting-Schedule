class MeetingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_meeting, only: [:show, :edit, :update, :destroy, :pdf]

  def index
    @meetings = Meeting.upcoming.limit(50)
  end

  def show
    @schedule_item = @meeting.schedule_items.build
  end

  def new
    @meeting = Meeting.new(date: Date.today)
  end

  def edit
  end

  def create
    @meeting = Meeting.new(meeting_params)
    if @meeting.save
      redirect_to @meeting, notice: "Reunión creada exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @meeting.update(meeting_params)
      redirect_to @meeting, notice: "Reunión actualizada exitosamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @meeting.destroy
    redirect_to meetings_url, notice: "Reunión eliminada exitosamente."
  end

  def pdf
    pdf = Prawn::Document.new
    pdf.text "Agenda de la reunión", size: 20, style: :bold, align: :center
    pdf.move_down 10
    pdf.text "Título: #{@meeting.title}", size: 14
    pdf.text "Fecha: #{I18n.l(@meeting.date)}"
    pdf.text "Lugar: #{@meeting.location}" if @meeting.location.present?
    pdf.move_down 10
    pdf.text "Notas:", style: :bold
    pdf.text @meeting.notes.to_s
    pdf.move_down 20
    pdf.text "Agenda detallada:", style: :bold

    @meeting.schedule_items.each_with_index do |item, i|
      pdf.move_down 8
      pdf.text "#{i + 1}. #{item.start_time.strftime("%H:%M")} - #{item.role} (#{item.speaker}) — #{item.duration_minutes} min"
      pdf.text "   #{item.notes}" if item.notes.present?
    end

    send_data pdf.render,
              filename: "reunion_#{@meeting.id}.pdf",
              type: "application/pdf",
              disposition: "inline"
  end

  private

  def set_meeting
    @meeting = Meeting.find(params[:id])
  end

  def meeting_params
    params.require(:meeting).permit(:title, :date, :location, :notes, :meeting_type)
  end
end
