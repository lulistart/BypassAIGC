# syntax=docker/dockerfile:1

FROM node:20-bookworm-slim AS frontend-builder

WORKDIR /build/frontend

COPY package/frontend/package*.json ./
RUN npm ci

COPY package/frontend/ ./
RUN npm run build


FROM python:3.11-slim AS runtime

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    SERVER_HOST=0.0.0.0 \
    SERVER_PORT=9800 \
    DATABASE_URL=sqlite:////data/ai_polish.db

WORKDIR /app

RUN mkdir -p /data

COPY package/backend/requirements.txt ./requirements.txt
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

COPY package/main.py ./main.py
COPY package/backend ./backend
COPY --from=frontend-builder /build/frontend/dist ./static
COPY docker-entrypoint.sh ./docker-entrypoint.sh

RUN sed -i 's/\r$//' ./docker-entrypoint.sh \
    && chmod +x ./docker-entrypoint.sh

EXPOSE 9800
VOLUME ["/data"]

HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
    CMD python -c "import os, urllib.request; port = os.environ.get('PORT', '9800'); urllib.request.urlopen(f'http://127.0.0.1:{port}/health', timeout=3).read()" || exit 1

ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port ${PORT:-9800}"]
