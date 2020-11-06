control "control-01" do
  describe command('vault auth list') do
    its('stdout') { should include "approle" }
  end
end

control "control-02" do
  describe json({ command: 'vault auth list -format json'}) do
    its(['database/approle/','type']) { should eq 'approle' }
    its(['database/approle/','config','default_lease_ttl']) { should eq 0 }
    its(['database/approle/','config','max_lease_ttl']) { should eq 0 }
  end
end

control "control-03" do
  describe vault_auth_method("database/approle/") do
    its('type') { should eq "approle" }
    its('default_lease_ttl') { should be 60 }
    its('max_lease_ttl') { should be 0 }
    its('token_type') { should eq "default-service" }
  end
end