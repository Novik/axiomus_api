require 'logger'

module AxiomusApi

  AXILOG_DEFAULTS =
  {
    endpoint: 'https://axilog.ru/atlas/api_xml.php',
    ukey: 'Qwersd56786786sdfy787232245xx774',
    uid: '12'
  }
  
  AXIOMUS_DEFAULTS =
  {
    endpoint: 'https://axiomus.ru/hydra/api_xml.php',
    ukey: 'XXcd208495d565ef66e7dff9f98764XX',
    uid: '92'
  }  

  @logger = Logger.new($stdout)
  @logger.level = Logger::INFO

  def self.logger=(val)
    @logger = val
  end

  def self.logger
    @logger
  end

end

require 'axiomus_api/actions'
require 'axiomus_api/errors'
require 'axiomus_api/response_codes'

Dir.glob(File.join(File.dirname(__FILE__),'axiomus_api/**/*.rb')).each do |file|
  require_relative(file)
end

