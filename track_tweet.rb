require 'tweetstream'
require 'isaac'
config = YAML.load_file('config.yml')

configure do |c|
  c.nick    = config['irc']['nick']
  c.server  = config['irc']['server']
  c.port    = config['irc']['port']
end

on :connect do
  join config['irc']['channel']
  t = Thread.new do
    TweetStream::Client.new(config['twitter']['login'],config['twitter']['password']).track(*config['twitter']['track']) do |status|
      # The status object is a special Hash with
      # method access to its keys.
      msg config['irc']['channel'], "[#{status.user.screen_name}] >>  #{status.text}"
    end
  end
end
