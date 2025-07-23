# -------- Stage 1: Build React App --------
    FROM node:20-alpine AS builder

    WORKDIR /app
    
    COPY package*.json ./
    RUN npm install
    
    COPY . .
    RUN npm run build
    
    # -------- Stage 2: Serve with Nginx --------
    FROM nginx:1.25-alpine AS production
    
    # Remove default nginx static assets
    RUN rm -rf /usr/share/nginx/html/*
    
    # Copy built React app from builder stage
    COPY --from=builder /app/build /usr/share/nginx/html
    
    # Copy custom nginx config (optional)
    # COPY nginx.conf /etc/nginx/nginx.conf
    
    EXPOSE 80
    
    CMD ["nginx", "-g", "daemon off;"]
    