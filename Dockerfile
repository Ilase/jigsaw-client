FROM ghcr.io/cirruslabs/flutter:latest AS build

WORKDIR /app
COPY pubspec.* ./
RUN flutter pub get

COPY . .

RUN flutter pub run build_runner build --delete-conflicting-outputs

RUN flutter build web --release

FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*

COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
