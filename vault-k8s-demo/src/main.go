package main

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/signal"
	"path"
	"syscall"

	"gopkg.in/yaml.v2"
)

type NotFoundRedirectRespWr struct {
	http.ResponseWriter
	status int
}

func (w *NotFoundRedirectRespWr) WriteHeader(status int) {
	w.status = status
	if status != http.StatusNotFound {
		w.ResponseWriter.WriteHeader(status)
	}
}

func (w *NotFoundRedirectRespWr) Write(p []byte) (int, error) {
	if w.status != http.StatusNotFound {
		return w.ResponseWriter.Write(p)
	}
	return len(p), nil
}

func Wrap(h http.Handler) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		rw := &NotFoundRedirectRespWr{ResponseWriter: w}
		h.ServeHTTP(rw, r)
		if rw.status == 404 {
			_, _ = fmt.Fprintf(w, "No secrets found!")
		}
	}
}

func processError(err error) {
	log.Fatal(err)
	os.Exit(2)
}

func main() {

	type Config struct {
		Database struct {
			User     string `yaml:"user"`
			Password string `yaml:"password"`
			Host     string `yaml:"host"`
			Port     int    `yaml:"port"`
			DbName   string `yaml:"dbname"`
			SslMode  string `yaml:"sslmode"`
		} `yaml:"database"`
	}

	secretpath := os.Getenv("VAULT_SECRET_PATH")
	if secretpath == "" {
		secretpath = "/vault/secrets"
	}

	c := make(chan os.Signal)
	signal.Notify(c, os.Interrupt, syscall.SIGTERM)
	go func() {
		<-c
		os.Exit(0)
	}()

	f, err := os.Open(path.Join(secretpath, "db-creds"))
	if err != nil {
		processError(err)
	}
	defer f.Close()

	var cfg Config
	decoder := yaml.NewDecoder(f)
	err = decoder.Decode(&cfg)
	if err != nil {
		processError(err)
	}

	psqlInfo := fmt.Sprintf("host=%s port=%d user=%s password=%s dbname=%s sslmode=%s",
		cfg.Database.Host, cfg.Database.Port, cfg.Database.User,
		cfg.Database.Password, cfg.Database.DbName, cfg.Database.SslMode)
	db, err := sql.Open("postgres", psqlInfo)
	if err != nil {
		panic(err)
	}
	defer db.Close()

	log.Println("Successfully connected!")

	fs := Wrap(http.FileServer(http.Dir(secretpath)))
	http.HandleFunc("/", fs)
	log.Println("Starting web server at 0.0.0.0:8080")
	log.Fatal(http.ListenAndServe(":8080", nil))

}
