# Use the latest official WordPress image
FROM wordpress:php8.1

# Install required system dependencies and PHP extensions (if any)

# Install Composer
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        unzip \
        && \
    rm -rf /var/lib/apt/lists/* && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set the working directory to the WordPress plugins directory
WORKDIR /var/www/html/wp-content/plugins/

# Copy the Pressbooks plugin files from the host to the container
COPY . /var/www/html/wp-content/plugins/pressbooks/

# Copy the Composer dependencies from the host to the container
COPY ./composer.json ./composer.lock ./
RUN composer install --no-dev --optimize-autoloader

# Set the working directory back to the WordPress root directory
WORKDIR /var/www/html/

# Set proper permissions for the WordPress files and directories
RUN chown -R www-data:www-data /var/www/html
