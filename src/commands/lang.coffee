module.exports.run = (client, message, args) ->

    languages = [
        ["en", "English"],
        ["fr", "Français"],
        ["it", "Italiano"],
        ["es", "español"]
    ]
    formattedLanguage = languages.map((l) -> """`#{l[0]}` (#{l[1]})""").join "\n"

    # Check if there is a new lang
    if not args[0] or not languages.some (l) -> l[0] is args[0]
        return client.createMessage message.channel.id,
        """
        :x: You must specify a valid new language!
        Available possibilies:
        #{formattedLanguage}
        """

    # Change the language
    client.db.set("""serversLanguages.#{message.channel.guild.id}""", args[0])
    .write()
    
    # Reply
    client.createMessage message.channel.id,
        """
        Simsimi language updated to `#{languages.find((l) -> l[0] is args[0])[1]}`
        """


module.exports.help = {
    name: "lang",
    onlyMod: true
}