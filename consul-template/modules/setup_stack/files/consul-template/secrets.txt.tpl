{{ with secret "secret/my-secret" }}
username: {{ .Data.username }}
password: {{ .Data.password }}
{{ end }}
