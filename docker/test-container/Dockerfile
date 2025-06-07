# Production-ready test container for AI News Feed ECS cluster
# This container provides a minimal web service for testing ECS deployments,
# health checks, and service discovery.

# Use Alpine Linux for minimal container size
# Alpine is a security-oriented, lightweight Linux distribution
FROM alpine:latest

# Set metadata for container identification
LABEL maintainer="AI News Feed Team"
LABEL description="Test container for ECS cluster validation"
LABEL version="1.0.0"

# Install required packages:
# - nodejs: Runtime for our test server
# - npm: Package manager (included with nodejs)
# - curl: For health check probes
# - dumb-init: Proper signal handling for containers
RUN apk add --no-cache \
    nodejs \
    npm \
    curl \
    dumb-init && \
    # Clean up package manager cache to reduce image size
    rm -rf /var/cache/apk/*

# Create a non-root user for security best practices
# Running containers as root is a security risk in production
RUN addgroup -g 1000 -S appuser && \
    adduser -u 1000 -S appuser -G appuser

# Create application directory with correct ownership
RUN mkdir -p /app && chown -R appuser:appuser /app

# Set working directory
WORKDIR /app

# Create the Node.js server using heredoc
# This approach keeps everything in one file for simplicity
RUN cat <<'EOF' > server.js
#!/usr/bin/env node

/**
 * Simple HTTP server for ECS cluster testing
 * Features:
 * - Lightweight and fast startup
 * - Graceful shutdown handling
 * - Health check endpoint
 * - Metadata endpoint for debugging
 */

const http = require('http');
const os = require('os');

// Configuration from environment variables with defaults
const PORT = process.env.PORT || 3000;
const HOST = '0.0.0.0'; // Listen on all interfaces

// Server instance
let server;

// Main response handler
const requestHandler = (req, res) => {
  // Set CORS headers for testing
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Content-Type', 'application/json');

  // Route handling
  switch (req.url) {
    case '/':
      // Main endpoint
      res.writeHead(200);
      res.end(JSON.stringify({
        message: 'AI News Feed Test Container Running!',
        timestamp: new Date().toISOString(),
        hostname: os.hostname(),
        version: '1.0.0'
      }, null, 2));
      break;

    case '/health':
      // Health check endpoint for ECS/ALB
      res.writeHead(200);
      res.end(JSON.stringify({
        status: 'healthy',
        uptime: process.uptime(),
        memory: process.memoryUsage(),
        timestamp: new Date().toISOString()
      }, null, 2));
      break;

    case '/metadata':
      // Debugging endpoint with system information
      res.writeHead(200);
      res.end(JSON.stringify({
        hostname: os.hostname(),
        platform: os.platform(),
        cpus: os.cpus().length,
        memory: {
          total: os.totalmem(),
          free: os.freemem()
        },
        network: os.networkInterfaces(),
        env: {
          NODE_ENV: process.env.NODE_ENV || 'production',
          ECS_CONTAINER_METADATA_URI: process.env.ECS_CONTAINER_METADATA_URI || 'not running in ECS'
        }
      }, null, 2));
      break;

    default:
      // 404 for unknown routes
      res.writeHead(404);
      res.end(JSON.stringify({
        error: 'Not Found',
        path: req.url
      }, null, 2));
  }
};

// Create HTTP server
server = http.createServer(requestHandler);

// Start server
server.listen(PORT, HOST, () => {
  console.log(`Server is running on http://${HOST}:${PORT}`);
  console.log('Available endpoints:');
  console.log('  / - Main endpoint');
  console.log('  /health - Health check');
  console.log('  /metadata - System information');
});

// Graceful shutdown handling
const shutdown = (signal) => {
  console.log(`\nReceived ${signal}, starting graceful shutdown...`);
  
  server.close(() => {
    console.log('HTTP server closed');
    process.exit(0);
  });

  // Force shutdown after 10 seconds
  setTimeout(() => {
    console.error('Forced shutdown after timeout');
    process.exit(1);
  }, 10000);
};

// Register shutdown handlers
process.on('SIGTERM', () => shutdown('SIGTERM'));
process.on('SIGINT', () => shutdown('SIGINT'));

// Handle uncaught errors
process.on('uncaughtException', (error) => {
  console.error('Uncaught Exception:', error);
  shutdown('uncaughtException');
});

process.on('unhandledRejection', (reason, promise) => {
  console.error('Unhandled Rejection at:', promise, 'reason:', reason);
  shutdown('unhandledRejection');
});
EOF

# Set correct permissions for the server file
RUN chown appuser:appuser server.js && \
    chmod 755 server.js

# Switch to non-root user
USER appuser

# Expose the application port
# This documents which port the container listens on
EXPOSE 3000

# Health check configuration
# ECS will use this to determine container health
# --interval: Check every 30 seconds
# --timeout: Wait 3 seconds for response
# --start-period: Give container 10 seconds to start
# --retries: Mark unhealthy after 3 failed checks
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1

# Use dumb-init to handle signals properly
# This ensures graceful shutdown and prevents zombie processes
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

# Run the Node.js server
CMD ["node", "server.js"]

# Build arguments for versioning (optional)
ARG BUILD_DATE
ARG BUILD_VERSION
ARG VCS_REF

# Additional labels for container registry scanning and tracking
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.version="${BUILD_VERSION}"
LABEL org.opencontainers.image.revision="${VCS_REF}"
LABEL org.opencontainers.image.title="AI News Feed Test Container"
LABEL org.opencontainers.image.description="Minimal test container for ECS cluster validation"
LABEL org.opencontainers.image.source="https://github.com/ai-news-feed/test-container"