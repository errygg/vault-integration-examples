{{ with secret "secret/mysecret" }}
secret: {{ .Data.myvalue }}
{{ end }}
