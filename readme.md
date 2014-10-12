# dogetip-slack
#### A Dogecoin tipping bot for [Slack](https://slack.com)

# Setup
1.  Install dogecoind on your server

  1. Usually this is done on linux by building from [source](https://github.com/dogecoin/dogecoin)
  2. Be sure to edit dogecoin.conf to set your rpcuser and rpcpassword
  3. Launch dogecoind -daemon and wait for the blockchain to sync

2. Clone this repo on your server

3. run `bundle install`

4. Set up the Slack integration: as an "outgoing webhook" (https://example.slack.com/services/new/outgoing-webhook)

  1. Write down the api token they show you in this page
  2. Set the trigger word: we use "dogetipper" but doesn't matter what you pick
  3. Set the Url to the server you'll be deploying on http://example.com:4567/tip

5. Set up your config.yml file

6. Launch the server!

  `bundle exec ruby dogetip.rb webook`

7. [Optional] Set up localtunnel.me so you can test your local development environment's integration with Slack.

  `lt --subdomain <your subdomain; e.g. mpdoge> --port <your port; e.g. 5678>`

8. [Optional] Set up your development console with useful aliases [1]:

  ```
  alias such=git
  alias very=git
  alias wow='git status'
  ```

  This will streamline development. e.g.

  ```
  $ wow
  $ such commit
  $ very push
  ```
  

# Commands

* Tip - send dogecoin!

  `dogetipper tip @somebody 100`
  `dogetipper tip @somebody random`

* Deposit - put dogecoin in

  `dogetipper deposit`

* Withdraw - take dogecoin out

  `dogetipper withdraw DKzHM7rUB2sP1dgVskVFfdSoysnojuw2pX 100`

* Balance - find out how much is in your wallet

  `dogetipper balance`

* Networkinfo - Get the output of getinfo.  Note:  this will disclose the entire aggregate balance of the hot wallet to everyone in the chat

  `dogetipper networkinfo`

# Security

## This runs an unencrypted hot wallet on your server.  ***This is not even close to secure.***  You should not store significant amounts of dogecoin in this wallet.  Withdraw your tips to an offline wallet often. 

# Developer resources

[A Linguist's Guide to Doge](http://the-toast.net/2014/02/06/linguist-explains-grammar-doge-wow/)

# References

[1] [https://imgur.com/UQAKbmN](https://imgur.com/UQAKbmN)