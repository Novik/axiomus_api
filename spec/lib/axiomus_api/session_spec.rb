require_relative '../../spec_helper'

describe 'AxiomusApi::Session' do
  before(:all) do
    AxiomusApi.logger.level = Logger::UNKNOWN

    @session = AxiomusApi.test_session
  end

  ORDER_MODES.each do |method|
    order_class = order_factory_name(method)

    describe "##{method}" do
      it 'should handle successful request' do
        HttpMocking.enqueue_response(DummyData.order_success_response(method))
        response = @session.send(method, build(order_class))
        expect(response.code).to eq 0
      end

      it 'should raise on error' do
        HttpMocking.enqueue_response(DummyData.order_error_response(method))
        expect{@session.send(method, build(order_class))}.to raise_error(AxiomusApi::Errors::RequestError)
      end
    end
  end

  describe '#get_regions' do
    it 'should handle successfull request' do
      HttpMocking.enqueue_response(DummyData::REGIONS_SUCCESS_RESPONSE)
      z = @session.get_regions()
      expect(z.regions.count).to eq 1
      expect(z.regions.first.code).to eq '21'
    end
  end

  describe '#status' do
    it 'should handle successfull request' do
      HttpMocking.enqueue_response(DummyData::STATUS_SUCCESS_RESPONSE)
      z = @session.status('2e3023c3e78f4f0c8cbb81257743c2d7')
      expect(z.order.id).to eq('1013')
      expect(z.order.inner_id).to eq('16777')
      expect(z.order.price).to eq(156.83)
      expect(z.status.code).to eq(211)
      expect(z.refused_items.count).to eq(1)
      expect(z.packs.count).to eq(1)
    end
  end

  it 'should accept a block' do
    HttpMocking.enqueue_response(DummyData::REGIONS_SUCCESS_RESPONSE)
    res = nil

    AxiomusApi.test_session do |s|
      res = s.get_regions
    end

    expect(res.regions.count).to eq 1
    expect(res.regions.first.code).to eq '21'
  end

  describe '#send_order_request' do
    it 'should raise on invalid order' do
      order = build(:dpd_order, :without_address)
      HttpMocking.enqueue_response(DummyData.order_success_response(:new_dpd))
      expect{@session.send_order_request(:new_dpd, order)}.to raise_error(AxiomusApi::Errors::ValidationError)
    end
  end

  describe '#labels_link' do
    it 'should return correct URL' do
      order_nums = []
      10.times {order_nums << rand(1..10000)}
      url = @session.labels_link(order_nums)
      order_nums.each do |on|
        expect(url).to include(on.to_s)
      end
    end
  end

end
