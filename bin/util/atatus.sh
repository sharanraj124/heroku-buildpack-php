#!/usr/bin/env bash

# install_atatus_ext() {
#     ATATUS_LICENSE_KEY=${ATATUS_LICENSE_KEY:-}
#     if [[ "$engine" == "php" && -n "$ATATUS_LICENSE_KEY" ]] && ! $engine -n $(which composer) show -d "$build_dir/.heroku/php" --installed --quiet heroku-sys/ext-atatus 2>/dev/null; then
#         if $engine -n $(which composer) require --update-no-dev -d "$build_dir/.heroku/php" -- "heroku-sys/ext-atatus:*" >> $build_dir/.heroku/php/install.log 2>&1; then
#             echo "- Atatus detected, installed ext-atatus" | indent
#         else
#             mcount "warnings.addons.atatus.extension_missing"
#             warning_inline "atatus detected, but no suitable extension available"
#         fi
#     fi
# }
install_atatus_ext() {
    # special treatment for New Relic; we enable it if we detect a license key for it
    # otherwise users would have to have it in their require section, which is annoying in development environments
    ATATUS_LICENSE_KEY=${ATATUS_LICENSE_KEY:-}
    if [[ -n "$ATATUS_LICENSE_KEY" ]] && ! php -n $(which composer1) show -d "$build_dir/.heroku/php" --installed --quiet heroku-sys/ext-atatus 2>/dev/null; then
        if php -n $(which composer1) require --update-no-dev -d "$build_dir/.heroku/php" -- "heroku-sys/ext-atatus:*" >> $build_dir/.heroku/php/install.log 2>&1; then
            echo "- Atatus detected, installed ext-atatus" | indent
        else
            mcount "warnings.addons.newrelic.extension_missing"
            warning_inline "New Relic detected, but no suitable extension available"
        fi
    fi
}

install_newrelic_userini() {
    if [[ -n "${NEW_RELIC_CONFIG_FILE:-}" ]]; then
        if [[ ! -f "${NEW_RELIC_CONFIG_FILE}" ]]; then
            mcount "failures.addons.newrelic.NEW_RELIC_CONFIG_FILE"
            error <<-EOF
                Config var 'NEW_RELIC_CONFIG_FILE' points to non existing file
                '${NEW_RELIC_CONFIG_FILE}'
            EOF
        fi
        notice_inline "Using custom New Relic config '${NEW_RELIC_CONFIG_FILE}'"
        ( cd $build_dir/.heroku/php/etc/php/conf.d; ln -s "../../../../../${NEW_RELIC_CONFIG_FILE}" "ext-atatus.user.ini" )
    fi
}
