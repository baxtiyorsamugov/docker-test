# Используем официальный образ PHP с FPM
FROM php:8.1-fpm

# Обновление репозиториев и установка необходимых библиотек
RUN apt-get update && apt-get install -y \
        libicu-dev \
        libonig-dev \
        libxml2-dev \
        unzip \
        nginx \
    && docker-php-ext-install intl mbstring xml pdo_mysql

# Устанавливаем Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Копируем файлы проекта в рабочую директорию
COPY . /var/www/html

# Назначаем права доступа для корректной работы веб-сервера
RUN chown -R www-data:www-data /var/www/html

# Настроим рабочую директорию для Nginx и PHP
WORKDIR /var/www/html

# Копируем конфигурацию Nginx в контейнер
COPY ./nginx.conf /etc/nginx/nginx.conf

# Открываем порты для Nginx и PHP-FPM
EXPOSE 80

# Стартуем Nginx и PHP-FPM
CMD service nginx start && php-fpm
