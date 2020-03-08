# Load config
config = require("../config.json")

# Create Discord Client
Eris = require("eris")
client = new Eris(config.token)
client.commands = []
client.config = config

# Create Simsimi Client
Simsimi = require("./simsimi")
client.simsimi = new Simsimi config.simsimi

# Init database
lowdb = require("lowdb")
FileSync = require("lowdb/adapters/FileSync")
adapter = new FileSync('./db.json')
db = lowdb(adapter)
db.defaults({ chatUses: {}, serversLanguages: {}, serversChannels: {} })
.write()
client.db = db

# Load commands
fs = require("fs")
fs.readdir """#{__dirname}/commands""", (err, data) ->
    if not data then return console.log """No command found..."""
    data.forEach (filePath) ->
        cmdData = require("""#{__dirname}/commands/#{filePath}""")
        client.commands.push({
            name: cmdData.help.name,
            run: cmdData.run
        })
        console.log """Loading Command: #{cmdData.help.name} 👌"""
    console.log """Loading a total of #{client.commands.length} commands!"""

client.on 'ready', ->
    console.log """
        Logged as #{client.user.username}##{client.user.discriminator}
    """

client.on 'messageCreate', (message) ->

    # Ignore bots
    if message.author.bot or not message.channel then return

    guildChannel = client.db.get("serversChannels").value()[message.channel.guild.id]
    if guildChannel and message.channel.id is guildChannel
    
        # Check uses
        userData = client.db.get("chatUses").value()[message.author.id] or 0
        if userData > 100
            return client.createMessage message.channel.id,
            """:x: Ratelimit exceeded. You can't send messages to simsimi anymore..."""

        # Try to get guild language
        guildLanguage = client.db.get("serversLanguages").value()[message.channel.guild.id]

        # Make the request
        res = await client.simsimi.request(message.content, guildLanguage)

        if not res.atext
            return message.addReaction "😢"

        # Reply
        client.createMessage message.channel.id,
        """#{res.atext}"""

        # Save uses
        client.db.set("""chatUses.#{message.author.id}""", userData + 1)
        .write()


    if not message.content.startsWith config.prefix then return

    args = message.content.slice(config.prefix.length).trim().split(/ +/g)
    command = args.shift().toLowerCase()

    commandFound = client.commands.find (cmdData) -> cmdData.name is command
    if not commandFound
        client.createMessage message.channel.id,
        """Unknown command. Send `#{config.prefix}help` to get the list of commands."""
    else
        if commandFound.help.onlyMod and message.member.permissions.json.manageMessages
            return client.createMessage message.channel.id, ":x: Only mods can run this command"
        commandFound.run client, message, args


# Login to Discord
client.connect()
