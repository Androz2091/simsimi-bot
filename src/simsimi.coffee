fetch = require("node-fetch")

class Simsimi
    constructor: (@token) ->

    request: (content, language, token) ->
        tokenToUse = if token then token else @token
        return new Promise (resolve, reject) ->
            fetch("https://wsapi.simsimi.com/190410/talk", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                    "x-api-key": tokenToUse
                },
                body: JSON.stringify({
                    utext: content,
                    lang: if language then language else "en"
                })
            }).then (res) ->
                data = await res.json().catch(() -> {})
                if not data
                    console.log await res.text()
                resolve data

module.exports = Simsimi
