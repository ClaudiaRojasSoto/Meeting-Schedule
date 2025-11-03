class Admin::MeetingsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def import_from_text
    @meeting = params[:id] ? Meeting.find(params[:id]) : Meeting.new
  end

  def process_import
    text = params[:meeting_text]
    
    # Validate that we have required data
    if text.blank?
      flash[:alert] = "Por favor pega el contenido de la reunión"
      redirect_to import_from_text_admin_meetings_path and return
    end
    
    if params[:meeting][:title].blank?
      flash[:alert] = "Por favor ingresa un título para la reunión"
      redirect_to import_from_text_admin_meetings_path and return
    end
    
    # Create or update meeting
    if params[:meeting][:id].present? && params[:meeting][:id] != ""
      @meeting = Meeting.find(params[:meeting][:id])
      @meeting.update!(meeting_import_params)
    else
      @meeting = Meeting.new(meeting_import_params)
      @meeting.save!
    end
    
    # Parse and create schedule items
    items_created = parse_and_create_items(text, @meeting)
    
    if items_created > 0
      redirect_to assign_speakers_admin_meeting_path(@meeting), notice: "✅ Reunión importada exitosamente con #{items_created} partes. Ahora asigna los participantes."
    else
      redirect_to @meeting, alert: "⚠️ Reunión creada pero no se encontraron partes para importar. Verifica el formato del texto."
    end
  rescue StandardError => e
    Rails.logger.error "Error importing meeting: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    @meeting ||= Meeting.new
    flash[:alert] = "Error al importar: #{e.message}"
    redirect_to import_from_text_admin_meetings_path
  end

  def assign_speakers
    @meeting = Meeting.find(params[:id])
    @unassigned_items = @meeting.schedule_items.where(speaker: [nil, ""])
    @users = User.where(role: "member").order(:name)
  end

  def bulk_assign
    @meeting = Meeting.find(params[:id])
    
    if params[:assignments].present?
      params[:assignments].each do |item_id, speaker_name|
        item = @meeting.schedule_items.find(item_id)
        item.update(speaker: speaker_name) if speaker_name.present?
      end
      
      redirect_to meeting_path(@meeting), notice: "Asignaciones guardadas exitosamente"
    else
      redirect_to assign_speakers_admin_meeting_path(@meeting), alert: "No se realizaron asignaciones"
    end
  end

  private

  def require_admin
    redirect_to root_path, alert: "No tienes permisos para acceder a esta sección." unless current_user&.admin?
  end

  def meeting_import_params
    params.require(:meeting).permit(:title, :date, :location, :notes, :meeting_type)
  end

  def parse_and_create_items(text, meeting)
    lines = text.split("\n").map(&:strip).reject(&:blank?)
    position = 1
    base_time = Time.parse("19:00")
    items_created = 0
    
    i = 0
    while i < lines.length
      line = lines[i]
      
      # Skip sections headers and non-assignable items
      if should_skip_line?(line)
        i += 1
        next
      end
      
      # Check if line starts with a number (indicates a meeting part)
      if line.match?(/^\d+\./)
        role = extract_role(line)
        
        # Collect multi-line notes and look for duration
        notes = line.gsub(/^\d+\.\s*/, "").strip
        duration = nil
        j = i + 1
        
        while j < lines.length && !lines[j].match?(/^\d+\./) && !lines[j].match?(/^(TESOROS|SEAMOS|NUESTRA)/)
          break if should_skip_line?(lines[j])
          
          # Check if this line has the duration
          if !duration && lines[j].match?(/\((\d+)\s*min/)
            duration = extract_duration(lines[j])
          end
          
          notes += " " + lines[j].strip
          j += 1
        end
        
        # Only create if it's an assignable part
        if is_assignable_part?(role, line)
          meeting.schedule_items.create!(
            role: role,
            start_time: base_time,
            duration_minutes: duration || 5,
            notes: notes[0..400],
            position: position
          )
          
          base_time += (duration || 5).minutes
          position += 1
          items_created += 1
          
          Rails.logger.info "✅ Created item #{items_created}: #{role} (#{duration || 5} mins)"
        end
      end
      
      i += 1
    end
    
    items_created
  end

  def extract_duration(text)
    match = text.match(/\((\d+)\s*min/)
    match ? match[1].to_i : nil
  end

  def should_skip_line?(line)
    return true if line.length < 5
    
    skip_patterns = [
      /^TESOROS/i,
      /^SEAMOS/i,
      /^NUESTRA/i,
      /^Canción/i,
      /^Serie de imágenes/i,
      /^PREGÚNTESE/i,
      /^Respuesta/i,
      /^Ponga el VIDEO/i,
      /^\?/,
      /^¿/
    ]
    
    skip_patterns.any? { |pattern| line.match?(pattern) }
  end

  def is_assignable_part?(role, full_line)
    return false if role.blank?
    
    # Skip only canciones (everything else with a number is assignable)
    skip_patterns = [
      /^Canción/i
    ]
    
    # If it matches any skip pattern, don't include it
    return false if skip_patterns.any? { |pattern| full_line.match?(pattern) }
    
    # Everything else with a number is assignable (including estudio bíblico, conclusión, etc.)
    true
  end

  def extract_role(text)
    # Extract the main title before the duration
    match = text.match(/^\d+\.\s*([^(]+)/)
    return text[0..80].strip unless match
    
    role = match[1].strip
    
    # Keep the full title, just clean it up a bit
    role[0..100].strip
  end
end
