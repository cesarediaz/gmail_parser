require 'nokogiri'

module GmailScrapper
  module Paypal
    def self.call(emails)
      emails = emails.class == File ? emails : emails.to_s.html_safe
      doc = Nokogiri::HTML.parse(emails)

      date = date(doc.at('span:contains("ART")'))
      company = company(doc.at('span:contains("Comercio")'))
      headers = %w(Descripción Precio\ por\ unidad Cantidad Importe)
      products = []
      cart = doc.at('table.CartTable')


      if cart
        products << company
        products << date
        cart.search('tr').each do |row|
          row.search('td').each do |cell|
            products << cell.text.strip unless headers.include?(cell.text.strip)
          end
        end
      end
      products
    end

    private

    def self.date(node_date)
      node_date.text.strip.split('ART')[0].strip if node_date
    end

    def self.company(node_company)
      node_company.next_element.next_element.text.strip if node_company
    end
  end
end

