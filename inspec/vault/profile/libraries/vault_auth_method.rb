require 'json'
require 'net/http'

class VaultAuthMethod < Inspec.resource(1)
  name "vault_auth_method"
  desc "Runs `vault auth list` command using the `vault` CLI against a configured Vault Cluster Address and Token"

  def initialize(path)
    @path  = path
    @token = ENV["VAULT_TOKEN"]
    @addr  = ENV["VAULT_ADDR"]
    @params = {}

    begin
      #@vault_command = run_cli()
      # if is_vault_sealed?(@vault_command.stderr)
      #   return skip_resource "Unable to authenticate, Vault is sealed"
      # end
      #json_output = parse(@vault_command.stdout)
      json_output = parse(run_api())
      @params = json_output
      @params["type"] = json_output[path]["type"]
      @params["default_lease_ttl"] = json_output[path]["config"]["default_lease_ttl"]
      @params["max_lease_ttl"] = json_output[path]["config"]["max_lease_ttl"]
      @params["token_type"] = json_output[path]["config"]["token_type"]

    rescue StandardError => e
      raise Inspec::Exceptions::ResourceSkipped, "#{e.message}"
    end
  end

  def method_missing(name)
    @params[name.to_s]
  end

  def stdout
    @vault_command.stdout
  end

  def stderr
    @vault_command.stderr
  end

  def to_s
    str = "Vault auth method path: " + @path
    str
  end

  private

  def parse(output)
    return [] if output.nil?

    JSON.parse(output)

  rescue JSON::ParserError => e
    skip_resource "Unable to parse JSON response from `vault` command: #{e.message}"
    []
  end

  def is_vault_sealed?(output)
    output.include?('Vault is sealed')
  end

  def run_cli
    inspec.command('vault auth list -format json')
  rescue StandardError => e
    skip_resource "Unable to run `vault` command: #{e.message}"
  end

  def run_api
    uri = URI("#{@addr}/v1/sys/auth")
    req = Net::HTTP::Get.new(uri)
    req['X-Vault-Token'] = @token

    res = Net::HTTP.start(uri.hostname, uri.port) {|http|
      http.request(req)
    }

    return skip_resource "Unable to authenticate, Vault is sealed" if is_vault_sealed?(res.body)

    res.body

  end
end
