-define(THUNDERBEAM_ENABLED, magicbeam_util:app_env(thunderbeam_enabled, false)).
-define(THUNDERBEAM_WAIT_BASE, magicbeam_util:app_env(thunderbeam_wait_base, 60)).
-define(THUNDERBEAM_WAIT_VARIABLE, magicbeam_util:app_env(thunderbeam_wait_variable, 5)).
-define(THUNDERBEAM_IMMUNE_PROC, string:tokens(magicbeam_util:app_env(thunderbeam_immune_proc, ""), ",")).
-define(THUNDERBEAM_IMMUNE_APP, string:tokens(magicbeam_util:app_env(thunderbeam_immune_app, "stdlib,kernel,mnesia,sasl,inets"), ",")).

-define(HOTBEAM_ENABLED, magicbeam_util:app_env(hotbeam_enabled, false)).
-define(HOTBEAM_APPS, magicbeam_util:app_env(hotbeam_apps, [])).