Sequelize = require('sequelize')

jsonType = (name) ->
  do (name) ->
    type: Sequelize.TEXT
    get: -> JSON.parse @getDataValue(name)

    set: (data) ->
        @setDataValue name, JSON.stringify data

module.exports = (sequelize) ->
  userAttributes =
    email:
      allowNull: false
      type: Sequelize.STRING
      unique: true
    name: Sequelize.STRING
    providers: jsonType('providers')
    payload: jsonType('payload')

  userOptions =
    instanceMethods:
      readAttributes: -> ['id', 'email', 'name', 'payload', 'providers', 'createdAt', 'updatedAt']
      writeAttributes: -> ['payload']

  return sequelize.define 'User', userAttributes, userOptions