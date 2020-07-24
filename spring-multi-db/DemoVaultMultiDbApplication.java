@SpringBootApplication
@RestController
public class DemoVaultMultiDbApplication {
  @RequestMapping("/")
  public String home() {
      return "Hello World!";
  }

  public static void main(String[] args) {
      SpringApplication.run(Application.class, args);
  }
}
