FROM node:14-alpine

WORKDIR /code

# 单独分离 package.json，是为了安装依赖可最大限度利用缓存
ADD package.json yarn.lock /code/
# 此时，yarn 可以利用缓存，如果 yarn.lock 内容没有变化，则不会重新依赖安装
RUN yarn

ADD . /code
RUN yarn && npm run build

CMD npx serve -s build
EXPOSE 3000