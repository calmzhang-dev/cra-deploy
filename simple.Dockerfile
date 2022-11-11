FROM node:14-alpine as builder

WORKDIR /code

# 单独分离 package.json，是为了安装依赖可最大限度利用缓存
ADD package.json yarn.lock /code/
# 此时，yarn 可以利用缓存，如果 yarn.lock 内容没有变化，则不会重新依赖安装
RUN yarn

ADD . /code
RUN yarn && npm run build

# CMD npx serve -s build
# EXPOSE 3000

# 选择更小体积的基础镜像 (builder 别名)
FROM nginx:alpine
# 将node镜像下 code/build 文件拷贝到 nginx 的 .html 文件目录下
COPY --from=builder code/build /usr/share/nginx/html