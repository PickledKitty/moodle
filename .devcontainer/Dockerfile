FROM moodlehq/moodle-php-apache:8.3

# Moodle 5.1+ serves only the public/ directory; everything else lives outside the web root.
RUN sed -ri 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/*.conf \
 && printf '%s\n' \
    '<Directory /var/www/html/public>' \
    '    AllowOverride All' \
    '    AcceptPathInfo On' \
    '    FallbackResource /r.php' \
    '</Directory>' > /etc/apache2/conf-available/moodle.conf \
 && a2enconf moodle

# Composer is needed to build vendor/ (Moodle 5.x depends on it at runtime).
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer
