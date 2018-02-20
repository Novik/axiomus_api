require_relative '../base'

class AxiomusApi::BoxberryServices < AxiomusApi::Base

  xml_attribute :cod, :checkup, :part_return, optional: true

end
