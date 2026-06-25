# ---- casino-frontend (Angular 17) — imagen de PRODUCCIÓN ----
# Multi-stage: 1) build con Node, 2) servir estáticos con nginx (+ reverse proxy).
# Esta es la imagen que publica el workflow en ECR y se despliega en EKS.

# 1) Build
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build   # genera dist/casino-frontend/browser/

# 2) Runtime con nginx
FROM nginx:alpine
# OJO: Angular 17 emite a dist/<proyecto>/browser/, no a dist/<proyecto>/.
COPY --from=build /app/dist/casino-frontend/browser/ /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
