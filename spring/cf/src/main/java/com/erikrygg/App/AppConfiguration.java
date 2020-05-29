package com.erikrygg.App;

import org.springframework.context.annotation.Configuration;
import org.springframework.vault.authentication.ClientAuthentication;
import org.springframework.vault.authentication.PcfAuthentication;
import org.springframework.vault.authentication.PcfAuthenticationOptions;
import org.springframework.vault.client.VaultEndpoint;
import org.springframework.vault.config.AbstractVaultConfiguration;

@Configuration
public class AppConfiguration extends AbstractVaultConfiguration {

  private String scheme;
  private String host;
  private String role;

  @Override
  public VaultEndpoint vaultEndpoint() {
    scheme = "http";
    host = "54.218.250.197";
    VaultEndpoint endpoint = new VaultEndpoint();
    endpoint.setScheme(scheme);
    endpoint.setHost(host);
    endpoint.setPort(8200);
    return endpoint;
  }

  @Override
  public ClientAuthentication clientAuthentication() {

    role = "vault-hacking-role";
    PcfAuthenticationOptions.PcfAuthenticationOptionsBuilder builder =
        PcfAuthenticationOptions.builder().role(role).path("pcf");

    return new PcfAuthentication(builder.build(), restOperations());
  }
}
