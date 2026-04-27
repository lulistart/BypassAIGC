# Zeabur Docker Deployment

This branch keeps the upstream application code unchanged and adds only Docker deployment files.

## Zeabur Settings

Deploy this repository from the `zeabur-deploy` branch.

- Provider: Dockerfile
- Root Directory: `/`
- Build Command: leave empty
- Start Command: leave empty

Zeabur auto-detects the root `Dockerfile` and injects `PORT` at runtime. The Docker command starts:

```sh
uvicorn main:app --host 0.0.0.0 --port ${PORT:-9800}
```

## Persistent Data

Add a Zeabur Volume mounted at:

```text
/data
```

Use this database URL:

```text
DATABASE_URL=sqlite:////data/ai_polish.db
```

Without the volume, SQLite data will be lost when the container is recreated.

The container also stores the runtime `.env` file at:

```text
/data/.env
```

At startup, `/app/.env` and `/app/backend/.env` are linked to this file so the admin system configuration page can save settings without losing them on redeploy.

## Required Environment Variables

Set these in Zeabur:

```text
DATABASE_URL=sqlite:////data/ai_polish.db
SECRET_KEY=replace-with-a-long-random-string
ADMIN_USERNAME=admin
ADMIN_PASSWORD=replace-with-a-strong-password
USE_STREAMING=false
```

Set model credentials according to your API provider:

```text
POLISH_MODEL=your-model
POLISH_API_KEY=your-api-key
POLISH_BASE_URL=https://your-openai-compatible-endpoint/v1

ENHANCE_MODEL=your-model
ENHANCE_API_KEY=your-api-key
ENHANCE_BASE_URL=https://your-openai-compatible-endpoint/v1

COMPRESSION_MODEL=your-model
COMPRESSION_API_KEY=your-api-key
COMPRESSION_BASE_URL=https://your-openai-compatible-endpoint/v1
```

## Local Docker Test

```sh
docker compose up --build
```

Then open:

```text
http://localhost:9800
```
