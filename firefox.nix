{pkgs, ...}: let
  # addons = inputs.firefox-addons.packages.${pkgs.system};
in {
  programs.firefox = {
    enable = true;
    profiles.coderdojo = {
      settings = {
        "browser.send_pings" = false;
        "browser.urlbar.speculativeConnect.enabled" = false;
        "dom.event.clipboardevents.enabled" = true;
        "media.navigator.enabled" = false;
        "network.cookie.cookieBehavior" = 1;
        "network.http.referer.XOriginPolicy" = 2;
        "network.http.referer.XOriginTrimmingPolicy" = 2;
        "beacon.enabled" = false;
        "browser.safebrowsing.downloads.remote.enabled" = false;
        "network.IDN_show_punycode" = true;
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
        "app.shield.optoutstudies.enabled" = false;
        "dom.security.https_only_mode_ever_enabled" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.toolbars.bookmarks.visibility" = "always";
        "geo.enabled" = false;

        # Disable telemetry
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.ping-centre.telemetry" = false;
        "browser.tabs.crashReporting.sendReport" = false;
        "devtools.onboarding.telemetry.logged" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.server" = "";

        # Disable Pocket
        "browser.newtabpage.activity-stream.feeds.discoverystreamfeed" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "extensions.pocket.enabled" = false;

        # Disable prefetching
        "network.dns.disablePrefetch" = true;
        "network.prefetch-next" = false;

        # Disable JS in PDFs
        "pdfjs.enableScripting" = false;

        # Harden SSL
        "security.ssl.require_safe_negotiation" = true;

        # Extra
        "identity.fxaccounts.enabled" = false;
        "browser.search.suggest.enabled" = false;
        "browser.urlbar.shortcuts.bookmarks" = false;
        "browser.urlbar.shortcuts.history" = false;
        "browser.urlbar.shortcuts.tabs" = false;
        "browser.urlbar.suggest.bookmark" = false;
        "browser.urlbar.suggest.engines" = false;
        "browser.urlbar.suggest.history" = false;
        "browser.urlbar.suggest.openpage" = false;
        "browser.urlbar.suggest.topsites" = false;
        "browser.uidensity" = 1;
        "media.autoplay.enabled" = false;
        "toolkit.zoomManager.zoomValues" = ".8,.90,.95,1,1.1,1.2";

        "privacy.firstparty.isolate" = true;
        "network.http.sendRefererHeader" = 0;
      };

      bookmarks = [
        {
          toolbar = true;
          bookmarks = [
            {
              url = "http://www.coderdojobelgium.be/nl";
              name = "CoderDojo Belgium";
            }
            {
              url = "https://scratch.mit.edu/";
              name = "Scratch - Imagine, Program, Share";
            }
            {
              url = "https://www.bingel.be/pupil/authentication/login";
              name = "Bingel";
            }
          ];
        }
      ];
      # extensions = with addons; [
      #   ublock-origin
      #   browserpass
      # ];
      settings = {
        "browser.disableResetPrompt" = true;
        "browser.download.panel.shown" = true;
        "browser.download.useDownloadDir" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.shell.defaultBrowserCheckCount" = 1;
        "browser.startup.homepage" = "https://www.coderdojobelgium.be/nl";
        "browser.uiCustomization.state" = ''{"placements":{"widget-overflow-fixed-list":[],"nav-bar":["back-button","forward-button","stop-reload-button","home-button","urlbar-container","downloads-button","library-button","ublock0_raymondhill_net-browser-action","_testpilot-containers-browser-action"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["tabbrowser-tabs","new-tab-button","alltabs-button"],"PersonalToolbar":["import-button","personal-bookmarks"]},"seen":["save-to-pocket-button","developer-button","ublock0_raymondhill_net-browser-action","_testpilot-containers-browser-action"],"dirtyAreaCache":["nav-bar","PersonalToolbar","toolbar-menubar","TabsToolbar","widget-overflow-fixed-list"],"currentVersion":18,"newElementCount":4}'';
        "dom.security.https_only_mode" = true;
        "privacy.trackingprotection.enabled" = true;
        "signon.rememberSignons" = false;
      };
    };
  };
  home = {
    sessionVariables.BROWSER = "firefox";
  };
  xdg.mimeApps.defaultApplications = {
    "text/html" = ["firefox.desktop"];
    "text/xml" = ["firefox.desktop"];
    "x-scheme-handler/http" = ["firefox.desktop"];
    "x-scheme-handler/https" = ["firefox.desktop"];
  };
}
