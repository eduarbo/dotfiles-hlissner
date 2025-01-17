{ config, lib, ... }:

{
  modules.services.gitea.enable = true;

  services.gitea = {
    appName = "Gitea";
    domain = "henrik.io";
    rootUrl = "https://git.henrik.io/";
    disableRegistration = true;
    settings = {
      server.SSH_DOMAIN = "henrik.io";
      mailer = {
        ENABLED = true;
        FROM = "noreply@mail.henrik.io";
        HOST = "smtp.mailgun.org:587";
        USER = "postmaster@mail.henrik.io";
        MAILER_TYPE = "smtp";
      };
    };
    mailerPasswordFile = config.age.secrets.gitea-smtp-secret.path;
  };

  services.nginx.virtualHosts."git.henrik.io" = {
    forceSSL = true;
    enableACME = true;
    root = "/srv/www/git.henrik.io";
    locations."/".proxyPass = "http://127.0.0.1:3000";
  };
}
