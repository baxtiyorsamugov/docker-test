FROM php:8.1-apache

# Обновление репозиториев и установка необходимых библиотек
RUN apt-get update && apt-get install -y \
        libicu-dev \
        libonig-dev \
        libxml2-dev \
        unzip \
    && docker-php-ext-install intl mbstring xml pdo_mysql

# Установка Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Включаем модуль Apache для поддержки ЧПУ
RUN a2enmod rewrite

# Копируем файлы проекта в рабочую директорию
COPY . /var/www/html

WORKDIR /var/www/html

# Назначаем права доступа для корректной работы веб-сервера
RUN chown -R www-data:www-data /var/www/html
