cd ../../app-spring/
./gradlew build
docker build --build-arg 'JAR_FILE=build/libs/*.jar' -t errygg/spring-vault-example .
