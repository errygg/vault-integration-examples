control "control-01" do
  describe input("/ui/approle", value: "approle") do
    it { should cmp "approle" }
  end
end