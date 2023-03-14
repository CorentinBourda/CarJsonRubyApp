RSpec.describe Rental do
  describe "price calculation" do
    context "with correct values and 1 day" do
      let(:rental) { Rental.new(1, 1, "2015-12-8", "2015-12-8", 100) }
      it "calculate right price" do
        expect(rental.price).to eq(3000)
      end
    end
    context "with correct values and 5 days" do
      let(:rental) { Rental.new(1, 1, "2015-12-8", "2015-12-12", 100) }
      it "calculate right price" do
        expect(rental.price).to eq(9800)
      end
    end
    context "with correct values and 15 days" do
      let(:rental) { Rental.new(1, 1, "2015-12-8", "2015-12-22", 100) }
      it "calculate right price" do
        expect(rental.price).to eq(21800)
      end
    end
  end
end
