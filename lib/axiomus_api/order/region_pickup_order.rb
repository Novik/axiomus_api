require_relative 'base_order'
require_relative '../address/region_pickup_address'

class AxiomusApi::RegionPickupOrder < AxiomusApi::BaseOrder

  xml_field :address, type: AxiomusApi::RegionPickupAddress

end
