require 'nokogiri'

module GmailScrapper
  def self.paypal(emails)
    emails = emails.class == File ? emails : emails.to_s.html_safe
    doc = Nokogiri::HTML.parse(emails)

    date = doc.at('span:contains("ART")').text.strip.split('ART')[0].strip
    company = doc.at('span:contains("Comercio")').next_element.next_element.text.strip
    headers = %w(Descripción Precio\ por\ unidad Cantidad Importe)

    products = []
    products << company
    products << date
    doc.at('table.CartTable').search('tr').each do |row|
      row.search('td').each do |cell|
        products << cell.text.strip unless headers.include?(cell.text.strip)
      end
    end 
    products      
  end
      
end

