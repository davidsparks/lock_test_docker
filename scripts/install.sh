#!/bin/bash

source ${PROJECT_BASE_DIR}/.env

cd ${DRUPAL_ROOT}

# Create a local alias '@default.dev'
mkdir -p "$HOME/.drush"
cat << __EOF__ > "$HOME/.drush/default.aliases.drushrc.php"
<?php
\$aliases['dev'] = array(
  'root' => '${DRUPAL_ROOT}',
  'uri' => 'localhost',
);
__EOF__

# Use Drush to install Drupal
/usr/bin/env PHP_OPTIONS="-d sendmail_path=`which true`" drush site-install -y "standard" --sites-subdir="default" --site-name="${PROJECT_NAME}" --account-name=admin --account-pass=admin

# Make settings.php writable:
chmod 755 ${DRUPAL_ROOT}/sites/default
chmod 644 ${DRUPAL_ROOT}/sites/default/settings.php

# Customise UI
drush dis -y dashboard overlay toolbar
drush en -y admin_menu

# Enable test module and flush cashes
drush en -y lock_test
drush cc all
