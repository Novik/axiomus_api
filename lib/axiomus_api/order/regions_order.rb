require_relative 'base_order'
require_relative '../services/regions_services'

class AxiomusApi::RegionsOrder < AxiomusApi::BaseOrder
  xml_attribute :d_date, :b_time, :e_time
  xml_attribute :incl_deliv_sum, optional: true
  xml_field :services, type: AxiomusApi::RegionsServices
end