require 'net/http'
require_relative 'actions'
require_relative 'response/regions_response'
require_relative 'response/status_response'
require_relative 'response/status_list_response'
require_relative 'response/version_response'
require_relative 'response/order_response'
require_relative 'response/carry_response'
require_relative 'response/pickup_response'

class AxiomusApi::Session
  include AxiomusApi::Actions

  def initialize(args={})
    @credentials = AxiomusApi::AXIOMUS_DEFAULTS.merge(args)
    if(block_given?)
      yield self
    end
  end

  ['', '_carry', '_export', '_self_export', '_post', '_dpd',
  '_ems', '_region_courier', '_region_pickup','_boxberry_pickup'].each do |suffix|
    [:new, :update].each do |prefix|
      m_name = "#{prefix}#{suffix}".to_sym
      define_method("#{prefix}#{suffix}") do |order|
        send_order_request(m_name, order)
      end
    end
  end

  def get_regions
    xml_request = create_request(:get_regions)
    xml_request.auth.ukey = @ukey
    response = send_request(xml_request)
    AxiomusApi::RegionsResponse.new (response.body)
  end

  def get_carries
    xml_request = create_request(:get_carry)
    xml_request.auth.ukey = @ukey
    response = send_request(xml_request)
    AxiomusApi::CarryResponse.new(response.body)
  end

  def get_boxberry_pickup
    xml_request = create_request(:get_boxberry_pickup)
    xml_request.auth.ukey = @ukey
    response = send_request(xml_request)
    AxiomusApi::PickupResponse.new(response.body)
  end

  def status(okey)
    xml_request = create_request(:status)
    xml_request.auth = nil
    xml_request.okey = okey
    response = send_request(xml_request)
    status_response = AxiomusApi::StatusResponse.new(response.body)
    status_response
  end

  def status_list(okeys)
    xml_request = create_request(:status_list)
    xml_request.auth = nil
    xml_request.okeys = okeys
    response = send_request(xml_request)
    status_response = AxiomusApi::StatusListResponse.new(response.body)
    status_response
  end

  def get_version
    xml_request = create_request(:get_version)
    xml_request.auth = nil
    response = send_request(xml_request)
    version_response = AxiomusApi::VersionResponse.new(response.body)
    version_response.version
  end

  def send_order_request(mode, order)
    if(!order.valid?)
      error_msg = order.validation_errors.join('\n')
      logger.error(error_msg)
      raise AxiomusApi::Errors::ValidationError.new, order.validation_errors.join(error_msg)
    end

    xml_request = get_order_request(mode, order)
    response = send_request(xml_request)
    order_response = AxiomusApi::OrderResponse.new(response.body)

    if !order_response.success?
      log_response_error(order_response.error_message, xml_request.to_xml, response.body)
      raise AxiomusApi::Errors::RequestError.new(order_response.code), order_response.error_message
    end

    order_response
  end

  private

  def get_order_request(mode, order)
    xml_request = create_request(mode)
    xml_request.auth.ukey = @credentials[:ukey]
    xml_request.order = order
    xml_request.prepare_checksum(@credentials[:uid])
    xml_request
  end

  def send_request(xml_request)
    uri = URI(@credentials[:endpoint])
    connection = Net::HTTP.new(uri.host, uri.port)
    connection.use_ssl = (uri.scheme == 'https')
    http_request = get_http_request(xml_request,uri.path)
    logger.info("Request to #{xml_request.mode}")
    logger.info("Request body: #{xml_request.to_xml(true)}")
    response = connection.request(http_request)
    logger.info("Response: #{response.code}")
    logger.info("Response raw: #{response.body}")
    response.body.gsub!(/^.*<\?xml/m, '<?xml')
    response
  end

  def get_http_request(xml_request,api_path)
    res = ::Net::HTTP::Post.new(api_path)
    res.body = "data=#{xml_request.to_xml(true)}"
    res
  end

  def logger
    ::AxiomusApi.logger
  end

  def log_response_error(description, xml_request, xml_response)
    logger.error(description)
    logger.error("Request body: #{xml_request}")
    logger.error("Response raw: #{xml_response}")
  end

end
