require "open-uri"
require "nokogiri"

class FetchJwMeetingsJob < ApplicationJob
  queue_as :default

  def perform(week_date = nil)
    week_date ||= Date.today
    
    url = build_url_for_week(week_date)
    
    begin
      html = URI.open(url).read
      doc = Nokogiri::HTML(html)

      title = extract_title(doc)
      date_range = extract_date_range(doc)
      
      return unless title && date_range

      meeting_date = parse_date_from_range(date_range)
      
      meeting = Meeting.find_or_create_by!(
        title: title,
        date: meeting_date
      ) do |m|
        m.meeting_type = "Entre Semana"
        m.pdf_url = url
      end

      extract_and_create_schedule_items(doc, meeting)

      Rails.logger.info "Reunión sincronizada: #{title} (#{date_range})"
    rescue StandardError => e
      Rails.logger.error "Error al obtener reuniones JW: #{e.message}"
    end
  end

  private

  def build_url_for_week(date)
    year = date.year
    month = date.strftime("%m")
    "https://www.jw.org/es/biblioteca/jw-meeting-workbook/#{year}/#{month}/"
  end

  def extract_title(doc)
    doc.at_css("h1")&.text&.strip
  end

  def extract_date_range(doc)
    doc.at_css(".todayDate, .dateRange")&.text&.strip
  end

  def extract_and_create_schedule_items(doc, meeting)
    sections = doc.css(".bodyTxt")
    position = 1

    sections.each do |section|
      section_title = section.at_css("h3, h2")&.text&.strip
      next unless section_title

      if section_title.include?("LECTURA DE LA BIBLIA") || section_title.include?("Lectura de la Biblia")
        extract_bible_reading(section, meeting, position)
        position += 1
      elsif section_title.include?("SEAMOS MEJORES MAESTROS") || section_title.include?("Seamos mejores maestros")
        position = extract_student_assignments(section, meeting, position)
      elsif section_title.include?("NUESTRA VIDA CRISTIANA") || section_title.include?("Nuestra vida cristiana")
        position = extract_christian_life_parts(section, meeting, position)
      end
    end
  end

  def extract_bible_reading(section, meeting, position)
    content = section.text
    duration = extract_duration(content)
    
    meeting.schedule_items.find_or_create_by!(position: position) do |item|
      item.start_time = Time.parse("19:05")
      item.duration_minutes = duration || 4
      item.role = "Lectura de la Biblia"
      item.notes = content.gsub("Lectura de la Biblia", "").strip.first(200)
    end
  end

  def extract_student_assignments(section, meeting, position)
    items = section.css("li, .schedule-item, p")
    
    items.each do |item_node|
      text = item_node.text.strip
      next if text.length < 10
      
      if text.match?(/\d+\./)
        duration = extract_duration(text)
        role_match = text.match(/\d+\.\s*(.+?)\(/)
        role = role_match ? role_match[1].strip : text.first(50)
        
        meeting.schedule_items.find_or_create_by!(position: position) do |item|
          item.start_time = calculate_start_time(position)
          item.duration_minutes = duration || 3
          item.role = role
          item.notes = text.gsub(/^\d+\.\s*/, "").first(250)
        end
        
        position += 1
      end
    end
    
    position
  end

  def extract_christian_life_parts(section, meeting, position)
    items = section.css("li, .schedule-item, p")
    
    items.each do |item_node|
      text = item_node.text.strip
      next if text.length < 10
      
      if text.match?(/\d+\./)
        duration = extract_duration(text)
        role_match = text.match(/\d+\.\s*(.+?)\(/)
        role = role_match ? role_match[1].strip : text.first(50)
        
        meeting.schedule_items.find_or_create_by!(position: position) do |item|
          item.start_time = calculate_start_time(position)
          item.duration_minutes = duration || 5
          item.role = role
          item.notes = text.gsub(/^\d+\.\s*/, "").first(250)
        end
        
        position += 1
      end
    end
    
    position
  end

  def extract_duration(text)
    match = text.match(/\((\d+)\s*min/)
    match ? match[1].to_i : nil
  end

  def calculate_start_time(position)
    base_time = Time.parse("19:00")
    base_time + ((position - 1) * 5).minutes
  end

  def parse_date_from_range(text)
    if text =~ /(\d+)[^\d]+de\s+(\w+)\s+de\s+(\d{4})/
      day = Regexp.last_match(1).to_i
      month = month_number(Regexp.last_match(2))
      year = Regexp.last_match(3).to_i
      Date.new(year, month, day)
    else
      Date.today
    end
  end

  def month_number(name)
    {
      "enero" => 1, "febrero" => 2, "marzo" => 3, "abril" => 4,
      "mayo" => 5, "junio" => 6, "julio" => 7, "agosto" => 8,
      "septiembre" => 9, "octubre" => 10, "noviembre" => 11, "diciembre" => 12
    }[name.downcase] || 1
  end
end
