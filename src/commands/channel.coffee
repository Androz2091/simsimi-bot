module.exports.run = (client, message, args) ->


    # Check if there is no channel
    if not args[0]
        client.db.set("""serversChannels.#{message.channel.guild.id}""", null)
        .write()
        return client.createMessage message.channel.id,
        """
        Simsimi channel successfully disabled!
        """

    # Parse channel
    channel = args[0].match(/^<#([0-9]{18})>/)
    if not channel
        return client.createMessage message.channel.id,
        """
        Please specify a valid channel!
        """
    
    # Change in db
    client.db.set("""serversChannels.#{message.channel.guild.id}""", channel[1])
    .write()

    # Reply
    client.createMessage message.channel.id,
        """
        Simsimi channel is now <##{channel[1]}>!
        """


module.exports.help = {
    name: "channel"
}