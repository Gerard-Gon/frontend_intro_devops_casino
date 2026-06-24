# --- ETAPA 1: Construcción (Build) ---
FROM node:20-alpine as builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build --configuration=production

# --- ETAPA 2: Servidor Web (Nginx no-root) ---
FROM nginxinc/nginx-unprivileged:alpine

# 1. Copia el build de Angular a la carpeta pública de nginx
COPY --from=builder /app/dist/casino-frontend/browser /usr/share/nginx/html

# 2. Copia tu archivo nginx.conf personalizado 
# La ruta de destino en la imagen es /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf

# El servidor nginx-unprivileged usa el 8080 por defecto
EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]