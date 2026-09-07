FROM node:25-alpine AS builder

WORKDIR /app

COPY package.json yarn.lock

COPY . . 

RUN yarn install

RUN yarn build

FROM node:25-alpine

WORKDIR /app

COPY --from=builder /app /app

#COPY --from=builder /app/node_modules /app/node_modules

EXPOSE 3000

RUN yarn global add serve

CMD [ "serve", "-s", "build" ]