# Updated Nightscout Dockerfile using Node 18
FROM node:18-alpine

LABEL maintainer="Nightscout Contributors"

# Set working directory
WORKDIR /opt/app

# Copy everything
ADD . /opt/app

# Install build tools and clean up after
RUN apk add --no-cache python3 make g++ \
 && mkdir -p /tmp/empty-cache \
 && npm install --cache /tmp/empty-cache \
 && npm run postinstall \
 && npm run env \
 && rm -rf /tmp/* /root/.npm /root/.cache

# Healthcheck for Render (optional but helpful)
HEALTHCHECK CMD wget -q -O - http://localhost:${PORT:-10000}/api/v1/status || exit 1

# Start Nightscout
CMD ["node", "lib/server/server.js"]
