include JsonInterface
RSpec.describe JsonInterface do
  describe "find_row" do
    context "with valid ID" do
      it "returns the correct hash" do
        correct_hash = {id: 1, car_id: 1, start_date: "2017-12-8", end_date: "2017-12-10", distance: 100}
        expect(JsonInterface.find_row(model_name: "rentals", id: 1)).to eq(correct_hash)
      end
    end

    context "with invalid ID" do
      it "raises ID cannot be found" do
        expect{JsonInterface.find_row(model_name: "rentals", id: 4)}.to raise_error("ID cannot be found")
      end
    end

    context "with invalid model name" do
      it "raises Model name cannot be found" do
        expect{JsonInterface.find_row(model_name: "users", id: 1)}.to raise_error("Model name cannot be found")
      end
    end
  end

  describe "parse_collection" do
    context "with valid model name" do
      it "returns the correct hash" do
        correct_collection = [{:id=>1, :car_id=>1, :start_date=>"2017-12-8", :end_date=>"2017-12-10", :distance=>100},
                              {:id=>2, :car_id=>1, :start_date=>"2017-12-14", :end_date=>"2017-12-18", :distance=>550},
                              {:id=>3, :car_id=>2, :start_date=>"2017-12-8", :end_date=>"2017-12-10", :distance=>150}]
        expect(JsonInterface.parse_collection(model_name: "rentals")).to eq(correct_collection)
      end
    end

    context "with invalid model name" do
      it "raises Model name cannot be found" do
        expect{JsonInterface.find_row(model_name: "users", id: 1)}.to raise_error("Model name cannot be found")
      end
    end
  end
end
