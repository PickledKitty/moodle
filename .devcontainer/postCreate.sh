#!/bin/bash
set -e

cd /var/www/html

# The repo is owned by the host user; let git (running as root) work with it.
git config --global --add safe.directory /var/www/html

echo "==> Copying config.php into place..."
cp .devcontainer/moodle-config.php config.php

# In Codespaces, Moodle must be reached via the forwarded HTTPS URL, not localhost.
if [ -n "$CODESPACE_NAME" ]; then
  WWWROOT="https://${CODESPACE_NAME}-8000.${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN}"
  sed -i "s#http://localhost:8000#${WWWROOT}#" config.php
  sed -i "s#^\$CFG->sslproxy.*#\$CFG->sslproxy  = true;#" config.php
  sed -i "s#^\$CFG->reverseproxy.*#\$CFG->reverseproxy = true;#" config.php
else
  WWWROOT="http://localhost:8000"
fi

echo "==> Installing Composer dependencies..."
composer install --no-interaction

echo "==> Fixing moodledata permissions..."
chown -R www-data:www-data /var/moodledata

echo "==> Installing Moodle database..."
if php admin/cli/install_database.php \
  --agree-license \
  --fullname="Moodle Dev" \
  --shortname="moodle_dev" \
  --adminpass="${MOODLE_ADMIN_PASS:-Admin1234!}" \
  --adminemail="null"; then
  echo "    Database installed."
else
  echo "    (install_database.php failed — normal if the DB is already installed; otherwise check output above)"
fi

# The installer ran as root; make sure Apache can write everything it created.
chown -R www-data:www-data /var/moodledata

if [ -n "$MOODLE_ADMIN_PASS" ]; then
  echo "==> Done! Visit ${WWWROOT} — log in as admin with your MOODLE_ADMIN_PASS secret"
else
  echo "==> Done! Visit ${WWWROOT} — admin / Admin1234! (set a MOODLE_ADMIN_PASS Codespaces secret to override)"
fi
