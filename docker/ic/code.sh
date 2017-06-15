#!/bin/bash
mkdir -p /app/default/var
chown -R www-data:www-data /app/*/var && tail -f /dev/null