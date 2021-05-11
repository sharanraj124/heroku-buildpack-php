#!/usr/bin/env bash

install_atatus_ext() {
    # special treatment for New Relic; we enable it if we detect a license key for it
    # otherwise users would have to have it in their require section, which is annoying in development environments
    ATATUS_LICENSE_KEY=${ATATUS_LICENSE_KEY:-}
    if [[ -n "$ATATUS_LICENSE_KEY" ]] && ! php -n $(which composer) show -d "$build_dir/.heroku/php" --installed --quiet heroku-sys/ext-atatus 2>/dev/null; then
        if php -n $(which composer) require --update-no-dev -d "$build_dir/.heroku/php" -- "heroku-sys/ext-atatus:*" >> $build_dir/.heroku/php/install.log 2>&1; then
            echo "- Atatus detected, installed ext-atatus" | indent
        else
            mcount "warnings.addons.atatus.extension_missing"
            warning_inline "Atatus detected, but no suitable extension available"
        fi
    fi
}
