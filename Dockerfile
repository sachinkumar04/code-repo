FROM node:alpine3.21

WORKDIR /APP

COPY . .

#RUN skip

EXPOSE 8000

CMD ["node", "app.js"]
