util = require("util")

module.exports.run = (client, message, args) ->

        
    content = message.content.split(" ").slice(1).join(" ")
    result = new Promise((resolve, reject) -> resolve(eval(content)))
        
    return result.then((output) ->
        if typeof output isnt "string"
            output = util.inspect(output, { depth: 0 })

        client.createMessage message.channel.id, """```js\n#{output}\n```"""
    ).catch((err) ->
        client.createMessage message.channel.id, """```js\n#{err.toString()}\n```"""
    )

module.exports.help = {
    name: "eval",
    onlyMod: true
}