cordova.define("cordova-plugin-upi-deeplink.UPILinkPlugin", function(require, exports, module) {
    var exec = require("cordova/exec");
    module.exports = {
        init: function(success, error) {
            try {
                exec(success, error, "UPILinkPlugin", "init", []);
            } catch (e) {
                console.warn("UPILinkPlugin not available in this build");
                if (error) error("Plugin not available");
            }
        }
    };
});
