module.exports.run = (client, message) ->
    # Ping
    sentMessage = await client.createMessage message.channel.id,
    ":ping_pong: Pong!"

    # Reply
    sentMessage.edit """:ping_pong: Pong! `#{Date.now() - sentMessage.timestamp}ms`"""

module.exports.help = {
    name: "ping"
}