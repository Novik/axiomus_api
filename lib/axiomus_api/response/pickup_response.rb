require 'nokogiri'

class AxiomusApi::PickupResponse

  attr_accessor :offices

  class Office
    attr_accessor :trip_description
    attr_accessor :card
    attr_accessor :cash
    attr_accessor :acquiring
    attr_accessor :delivery_period
    attr_accessor :tariff_zone
    attr_accessor :phone
    attr_accessor :only_prepaid_orders
    attr_accessor :work_schedule
    attr_accessor :area
    attr_accessor :gps
    attr_accessor :city_name
    attr_accessor :city_code
    attr_accessor :metro
    attr_accessor :office_address
    attr_accessor :office_name
    attr_accessor :office_code

    def initialize(node)
      @trip_description    = node.xpath('@TripDescription').text
      @card                = node.xpath('@card').text.to_i
      @cash                = node.xpath('@cash').text.to_i
      @acquiring           = node.xpath('@Acquiring').text.to_i
      @delivery_period     = node.xpath('@DeliveryPeriod').text.to_i
      @tariff_zone         = node.xpath('@TariffZone').text.to_i
      @phone               = node.xpath('@Phone').text
      @only_prepaid_orders = node.xpath('@OnlyPrepaidOrders').text.to_i
      @work_schedule       = node.xpath('@WorkSchedule').text
      @area                = node.xpath('@Area').text
      @gps                 = node.xpath('@GPS').text
      @city_name           = node.xpath('@city_name').text
      @city_code           = node.xpath('@city_code').text
      @metro               = node.xpath('@Metro').text
      @office_address      = node.xpath('@office_address').text
      @office_name         = node.xpath('@office_name').text
      @office_code         = node.xpath('@office_code').text.to_i
    end
  end

  def initialize(xml)
    doc = Nokogiri::XML(xml)
    @offices = doc.xpath('response/pickup_list/office').map do |node|
      Office.new(node)
    end
  end
end
