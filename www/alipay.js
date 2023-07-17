var exec = require('cordova/exec');

module.exports = {
    payment: (payInfo, success, error) => {
        exec(success, error, "alipay", "payment", [payInfo]);
    },

    isAliPayInstalled: (success, error) => {
        exec(success, error, "alipay", "isAliPayInstalled", []);
    }
};