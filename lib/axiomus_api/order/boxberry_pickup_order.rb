require_relative 'region_order'
require_relative '../address/boxberry_pickup_address'
require_relative '../services/boxberry_services'

class AxiomusApi::RegionPickupOrder < AxiomusApi::BaseOrder

  xml_attribute :d_date
  xml_field :address, type: AxiomusApi::BoxberryPickupAddress
  xml_attribute :incl_deliv_sum, :email, optional: true
  xml_field :services, type: AxiomusApi::BoxberryServices

end
