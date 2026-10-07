FROM node:25-alpine AS builder
WORKDIR /app
COPY package.json yarn.lock .
COPY . .
RUN yarn install
RUN yarn build



# Runtime: nginx serves the static React build. The unprivileged image runs as a
# non-root user (nginx, uid 101) and is much smaller than a Node.js image.
FROM nginxinc/nginx-unprivileged:stable-alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 3000
