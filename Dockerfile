# Use PHP 7.4 with Apache as base image
FROM php:7.4-apache

# Install required PHP extensions (Fileinfo, Imagick, Redis)
RUN apt-get update && apt-get install -y \
    libmagickwand-dev \
    libpng-dev \
    libssl-dev \
    && docker-php-ext-install pdo pdo_mysql fileinfo \
    && pecl install imagick redis \
    && docker-php-ext-enable imagick redis \
    && apt-get clean


# Enable Apache mod_rewrite and mod_ssl for SSL support
RUN a2enmod rewrite ssl

# Node Js Install
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g pm2
# Expose Apache ports
EXPOSE 80 443 12087 12053 12096

# Set working directory
WORKDIR /var/www/html
# Install Composer (for Laravel)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set permissions for Laravel (important for storage and cache directories)
# COPY . /var/www/html
RUN chown -R www-data:www-data /var/www/html
RUN chown -R 775 /var/www/html

# Restart Apache to apply changes
# RUN service apache2 restart

# Default command to run Apache in the foreground
CMD ["apache2-foreground"]
