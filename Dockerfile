# Use official Node.js image
FROM node:20-alpine

# Install build dependencies
RUN apk add --no-cache python3 make g++

# Set working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install

# Copy application code
COPY . .

# Build the TypeScript code
RUN npm run build

# Expose port
EXPOSE 3000

# Run the application
CMD ["node", "dist/index.js"]