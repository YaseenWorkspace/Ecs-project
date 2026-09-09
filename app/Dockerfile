FROM node:25-alpine AS builder
WORKDIR /app
COPY package.json yarn.lock
COPY . .
RUN yarn install
RUN yarn build



FROM node:25-alpine
WORKDIR /app
COPY --from=builder /app/build /app/build
EXPOSE 3000
RUN yarn global add serve 
RUN adduser -S appuser 
RUN chown -R appuser /app/build
USER appuser
CMD [ "serve", "-s", "build" ]



