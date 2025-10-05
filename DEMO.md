```bash
curl -X GET "http://localhost:14040/health"
```

```bash
curl -X POST "http://localhost:14040/synthesize" \
  -H "Content-Type: application/json" \
  -d '{"text":"Merhaba, bu bir test mesajıdır."}' \
  --output speech.wav
```