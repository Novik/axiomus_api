require_relative '../base'

class AxiomusApi::BoxberryServices < AxiomusApi::Base

  xml_attribute :cod, :checkup, :part_return, :card, :cheque, optional: true

end
