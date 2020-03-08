module.exports.run = (client, message, args) ->

    # Check if there is a message to send
    if not args[0]
        return client.createMessage message.channel.id,
        """:x: You must specify something to say to Simsimi!"""

    userData = client.db.get("chatUses").value()[message.author.id] or 0
    if userData > client.config.maxRequestPerUser
        return client.createMessage message.channel.id,
        """:x: Ratelimit exceeded. You can't send messages to simsimi anymore..."""

    # Try to get guild language
    guildLanguage = client.db.get("serversLanguages").value()[message.channel.guild.id]

    # Make the request
    res = await client.simsimi.request(args.join(" "), guildLanguage)

    if not res.atext
        return message.addReaction "😢"

    # Reply
    client.createMessage message.channel.id,
    """#{res.atext}"""

    # Save uses
    client.db.set("""chatUses.#{message.author.id}""", userData + 1)
    .write()


module.exports.help = {
    name: "chat",
    onlyMod: false
}