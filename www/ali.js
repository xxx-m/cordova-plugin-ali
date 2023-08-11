var exec = require('cordova/exec');

module.exports = {
    payment: (payInfo, success, error) => {
        exec(success, error, "ali", "payment", [payInfo]);
    },

    isAliPayInstalled: (success, error) => {
        exec(success, error, "ali", "isAliPayInstalled", []);
    }
};