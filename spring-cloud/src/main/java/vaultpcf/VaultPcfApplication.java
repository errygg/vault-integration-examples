package vaultpcf;

import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.vault.core.VaultKeyValueOperationsSupport.KeyValueBackend;
import org.springframework.vault.core.VaultTemplate;
import org.springframework.vault.support.VaultResponse;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


@SpringBootApplication
@RestController
@Slf4j
public class VaultPcfApplication implements CommandLineRunner {

    @Autowired
    private VaultTemplate vaultTemplate;

    public static void main(String[] args) {
        SpringApplication.run(VaultPcfApplication.class, args);
    }

    @Value("${username}")
    public String username;

    @Value("${password}")
    public String password;

    @Override
    public void run(String... strings) {

      // Read values using injection
      log.info("'username' injected via @Value : {}", username);
      log.info("'password' injected via @Value : {}", password);


      // Read values directly
      VaultResponse response = vaultTemplate.opsForKeyValue("kv", KeyValueBackend.KV_2).get("vaultpcf");
      log.info("'username' from response: {}", response.getData().get("username"));
      log.info("'username' from response: {}", response.getData().get("password"));

      // Dynamic Postgres database example
      // TODO

    }

    @RequestMapping("/")
    public String home() {
      return "Hello, " + username + " " + password;
    }

}
