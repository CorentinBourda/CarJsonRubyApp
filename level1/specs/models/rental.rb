RSpec.describe Rental do
  describe "price calculation" do
    context "with correct values" do
      let(:rental) { Rental.new(1, 1, "2017-12-8", "2017-12-10", 100) }
      it "calculate right price" do
        expect(rental.price).to eq(7000)
      end
    end
  end
end
