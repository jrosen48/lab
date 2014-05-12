/*global define */
define(function (require) {

  var labConfig        = require('lab.config'),
      mustache         = require('mustache'),
      inherit          = require('common/inherit'),
      BasicDialog      = require('common/controllers/basic-dialog'),
      getCopyright     = require('common/controllers/copyright'),
      creditsDialogTpl = require('text!common/controllers/credits-dialog.tpl');

  /**
   * Credits Dialog. Inherits from Basic Dialog.
   *
   * @constructor
   */
  function CreditsDialog(parentSelector, i18n) {
    BasicDialog.call(this, {dialogClass: "credits-dialog", appendTo: parentSelector});
    this._i18n = i18n;
  }
  inherit(CreditsDialog, BasicDialog);

  /**
   * Updates dialog content using interactive JSON definition.
   *
   * @param {Object} interactive Interactive JSON definition.
   */
  CreditsDialog.prototype.update = function(interactive) {
    var hash           = document.location.hash,
        origin         = document.location.href.match(/(.*?\/\/.*?)\//)[1],
        embeddablePath = document.location.pathname,
        i18n           = this._i18n,
        concordUrl     = 'http://concord.org',
        nextGenUrl     = 'http://mw.concord.org/nextgen/',
        interactiveCreditsUrl,
        utmString;

    this.set("title", this._i18n.t("credits_dialog.title", {interactive_title: interactive.title}));

    if (labConfig.homeForSharing) {
      interactiveCreditsUrl = labConfig.homeForSharing + labConfig.homeEmbeddablePath + hash;
    } else {
      interactiveCreditsUrl = origin + embeddablePath + hash;
    }

    if (labConfig.utmCampaign) {
      utmString = "utm_source=" + encodeURIComponent(interactive.title.replace(/ /gi,"+")) +
        "&utm_medium=embedded_interactive&utm_campaign=" + labConfig.utmCampaign;
      concordUrl += "?" + utmString;
      nextGenUrl += "?" + utmString;
      interactiveCreditsUrl += "?" + encodeURI("utm_source=embed_link&utm_medium=embedded_interactive&utm_campaign=" + labConfig.utmCampaign);
    }

    var view = {
      credits_text: i18n.t("credits_dialog.credits_text", {
        CC_link: "<a class='opens-in-new-window' href='" + concordUrl + "' target='_blank'>Concord Consortium</a>",
        Next_Gen_MW_link: "<a class='opens-in-new-window' href='" + nextGenUrl + " ' target='_blank'>Next-Generation Molecular Workbench</a>",
        Google_link: "<a class='opens-in-new-window' href='http://www.google.org/' target='_blank'>Google.org</a>"
      }),
      find_shareable: i18n.t("credits_dialog.find_shareable", {
        shareable_ver_link: '<a href="' + interactiveCreditsUrl + '" class="opens-in-new-window" target="_blank">' + i18n.t('credits_dialog.shareable_ver') + '</a>',
        concord_org_link: '<a href="' + concordUrl + '" class="opens-in-new-window" target="_blank">concord.org</a>'
      }),
      copyright: getCopyright(i18n)
    };

    if (!labConfig.sharing) {
      view.showShareable = true;
    }

    this.setContent(mustache.render(creditsDialogTpl, view));
  };

  return CreditsDialog;
});
