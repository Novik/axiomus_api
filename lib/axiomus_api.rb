require 'logger'

module AxiomusApi
  AXIOMUS_API_VERSION = '2.12'
  AXIOMUS_PROD_PATH = '/atlas/api_xml.php'
  AXIOMUS_TEST_PATH = '/test/api_xml_test.php'
  AXIOMUS_ENDPOINT = 'https://axilog.ru'
  AXIOMUS_TEST_CREDENTIALS = {ukey: 'Qwersd56786786sdfy787232245xx774', uid: '12'}

  @logger = Logger.new($stdout)
  @logger.level = Logger::INFO

  def self.logger=(val)
    @logger = val
  end

  def self.logger
    @logger
  end

  def self.test_session(&block)
    session = AxiomusApi::Session.new(AXIOMUS_TEST_CREDENTIALS[:uid], AXIOMUS_TEST_CREDENTIALS[:ukey], true, &block)
  end

end

require 'axiomus_api/actions'
require 'axiomus_api/errors'
require 'axiomus_api/response_codes'

Dir.glob(File.join(File.dirname(__FILE__),'axiomus_api/**/*.rb')).each do |file|
  require_relative(file)
end

