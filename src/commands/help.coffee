module.exports.run = (client, message, args) ->
    # Reply
    client.createMessage message.channel.id,
    """
    :information_source: Here is the command list:
    `#{client.config.prefix}chat` - Send something to Simsimi
    `#{client.config.prefix}ping` - Get the bot latency
    `#{client.config.prefix}lang` - Change Simsimi language in your server
    `#{client.config.prefix}channel` - Define a channel to chat with Simsimi
    """

module.exports.help = {
    name: "help"
}