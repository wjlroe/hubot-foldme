# Description
#   A hubot script that makes your day better with pictures of Scottish Folds
#
# Commands:
#   hubot fold me - Reply with an image of a Scottish Fold
#   hubot fold bomb - Reply with multiple random images of Scottish Folds
#   hubot how many folds are there - Reply with the number of Scottish Folds available
#
# Author:
#   William Roe <git@wjlr.org.uk>

module.exports = (robot) ->
  robot.respond /fold me/i, (msg) ->
    robot.http("http://foldme.herokuapp.com/random")
      .get() (err, res, body) ->
        if err
          msg.reply "Had a problem fetching a random Scottish Fold"
          return
        msg.send JSON.parse(body).scotch_fold

  robot.respond /fold bomb/i, (msg) ->
    robot.http("http://foldme.herokuapp.com/bomb?count=5")
      .get() (err, res, body) ->
        if err
          msg.reply "Had a problem fetching a Scottish Fold bomb"
          return
        msg.send fold for fold in JSON.parse(body).scotch_folds

  robot.respond /how many (scottish )?folds are there(\?)?/i, (msg) ->
    robot.http("http://foldme.herokuapp.com/count")
      .get() (err, res, body) ->
        if err
          msg.reply "Had a problem fetching the number of Scottish Folds"
          return
        msg.send "There are #{JSON.parse(body).fold_count} Scottish Folds"
