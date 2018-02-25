{{ with $secret := vault "secret/test" }}
username: {{ $secret.Data.username }}
password: {{ $secret.Data.password }}
{{ end }}
