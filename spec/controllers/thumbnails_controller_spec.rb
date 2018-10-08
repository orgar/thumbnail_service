require 'rails_helper'

RSpec.describe ThumbnailsController, :type => :controller do

  describe "private methods" do
    it "get_ipad_ratio" do
      expect(controller.send(:get_ipad_ratio, 400,400)).to eq(1)
      expect(controller.send(:get_ipad_ratio, 1200,840)).to eq(0.7)
      expect(controller.send(:get_ipad_ratio, 450,600)).to eq(1)
    end

    it "validate_params" do
      expect(controller.send(:validate_params, {url: "http://tryme.com", width: '400', height: '500'})).to be_nil
      expect(controller.send(:validate_params, {width: '400', height: '500'})).to eql("Missing one of the following parameters: url, width, height")
      expect(controller.send(:validate_params, {url: "http://tryme.com", height: 500})).to eql("Missing one of the following parameters: url, width, height")
      expect(controller.send(:validate_params, {url: "http://tryme.com", width: 400})).to eql("Missing one of the following parameters: url, width, height")
      expect(controller.send(:validate_params, {url: "http://tryme.com", width: '400', height: 'fdhgh'})).to eql("Height is invalid")
      expect(controller.send(:validate_params, {url: "http://tryme.com", width: 'gfhgff', height: '500'})).to eql("Width is invalid")
    end
  end


  describe "public methods" do
    it "GET /thumbnail" do
      get :ipad_thumbnail
      expect(response.status).to eq(400)
      expect(JSON.parse(response.body)).to eq({"message"=>"Missing one of the following parameters: url, width, height"})

      get :ipad_thumbnail, params: {url: "http://errrororororor.dffs", width: '400', height: '500'}
      expect(response.status).to eq(400)
      expect(JSON.parse(response.body)['message']).to eql("Fail to download file from url. Failed to open TCP connection to errrororororor.dffs:80 (getaddrinfo: nodename nor servname provided, or not known)")
      400
    end
  end

  private
  def controller
    @controller ||= ThumbnailsController.new
  end

end
