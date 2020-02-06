package com.hashicorp.vault.demovault;

public class DemoVaultApplication {

  @Value("${spring.application.name}")
  private String appName;

  public static void main(String[] args) {
		SpringApplication.run(DemoVaultApplication.class, args);
	}
}