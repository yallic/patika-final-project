
FROM node:14-alpine


# apk add --no-cache libc6-compat

EXPOSE 80


WORKDIR /usr/src/app
COPY package.json .
RUN npm install
COPY . .

CMD [ "npm", "start" ]
