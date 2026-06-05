# ---------- Build Stage ----------
    FROM node:20-alpine AS build

    WORKDIR /app
    
    # Copy package files
    COPY package*.json ./
    
    # Install dependencies
    RUN npm install --legacy-peer-deps
    
    # Copy source code
    COPY . .
    
    # Build application
    RUN npm run build
    
    
    # ---------- Production Stage ----------
    FROM node:20-alpine
    
    WORKDIR /app
    
    # Copy package files
    COPY package*.json ./
    
    # Install production dependencies only
    RUN npm install --omit=dev --legacy-peer-deps
    
    # Copy app from build stage
    COPY --from=build /app .
    
    # React app runs on 3000 inside container
    ENV HOST=0.0.0.0
    ENV PORT=3000
    
    EXPOSE 3000
    
    CMD ["npm", "start"]