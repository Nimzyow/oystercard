require "station"

describe Station do
  context "stores" do
    it "name" do
      expect(described_class.new("Liverpool Street", 2)).to respond_to(:name)
    end
    it "zone" do
      expect(described_class.new("Liverpool Street", 2)).to respond_to(:zone)
    end
  end
end