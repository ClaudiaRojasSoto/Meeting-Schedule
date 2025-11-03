namespace :jw do
  desc "Test JW.org scraper"
  task test_scraper: :environment do
    require "open-uri"
    require "nokogiri"
    
    puts "🔍 Probando scraper de JW.org..."
    
    # Probar diferentes formatos de URL
    urls = [
      "https://www.jw.org/es/biblioteca/jw-meeting-workbook/",
      "https://www.jw.org/es/biblioteca/jw-meeting-workbook/noviembre-2025/",
      "https://www.jw.org/es/biblioteca/reuniones-vida-y-ministerio/noviembre-2025/",
      "https://www.jw.org/es/biblioteca/jw-meeting-workbook/programacion-vida-y-ministerio-noviembre-2025-mwb/",
    ]
    
    url = urls[0]
    
    puts "📡 URL: #{url}"
    
    begin
      html = URI.open(url).read
      doc = Nokogiri::HTML(html)
      
      puts "\n📄 HTML obtenido: #{html.length} caracteres"
      
      title = doc.at_css("h1")&.text&.strip
      puts "\n📋 Título encontrado: #{title || 'NO ENCONTRADO'}"
      
      date_range = doc.at_css(".todayDate, .dateRange, .contextTitle")&.text&.strip
      puts "📅 Fecha encontrada: #{date_range || 'NO ENCONTRADO'}"
      
      puts "\n🔍 Buscando secciones..."
      sections = doc.css(".section, article, .bodyTxt")
      puts "📦 Secciones encontradas: #{sections.count}"
      
      sections.first(5).each_with_index do |section, i|
        puts "\n--- Sección #{i + 1} ---"
        puts section.text[0..200].strip
      end
      
      puts "\n🔍 Buscando items específicos..."
      items = doc.css("li, p")
      bible_reading = items.find { |item| item.text.include?("Lectura de la Biblia") || item.text.include?("LECTURA DE LA BIBLIA") }
      
      if bible_reading
        puts "\n✅ Lectura de la Biblia encontrada:"
        puts bible_reading.text.strip
      else
        puts "\n❌ Lectura de la Biblia NO encontrada"
      end
      
    rescue StandardError => e
      puts "\n❌ Error: #{e.message}"
      puts e.backtrace.first(5)
    end
  end
end

