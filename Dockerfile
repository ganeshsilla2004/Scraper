# Stage 1: Node.js scraper with Puppeteer
FROM node:18.19.1-slim AS scraper

RUN apt-get update && apt-get install -y \
    chromium \
    fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf \
    --no-install-recommends && rm -rf /var/lib/apt/lists/*

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

WORKDIR /app

COPY scraper/package.json ./
RUN npm install

COPY scraper/scrape.js ./


ENV SCRAPE_URL=https://example.com

# Stage 2: Python Flask server
FROM python:3.10.13-slim AS server

WORKDIR /app


RUN apt-get update && apt-get install -y \
    nodejs npm chromium \
    fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf \
    --no-install-recommends && rm -rf /var/lib/apt/lists/*

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

COPY --from=scraper /app/node_modules /app/node_modules
COPY scraper/scrape.js .
COPY server/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY server/server.py .


COPY startup.sh .
RUN chmod +x startup.sh

EXPOSE 5000

ENV FLASK_APP=server.py \
    FLASK_ENV=production


CMD ["./startup.sh"]