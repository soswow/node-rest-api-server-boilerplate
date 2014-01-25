Sequelize = require('sequelize')
sequelize = new Sequelize('database', 'username', 'password',
  dialect: 'sqlite'
  storage: 'database.sqlite'
)

User = sequelize.define 'User',
  email:
    type: Sequelize.STRING
    unique: true
  name: Sequelize.STRING
  data:
    type: Sequelize.TEXT
    get: ->
      JSON.parse @getDataValue('data')
    set: (data) ->
      @setDataValue 'data', JSON.stringify data

module.exports =
  User: User
  init: (cb) ->
    sequelize.sync().done cb