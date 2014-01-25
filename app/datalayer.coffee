Sequelize = require('sequelize')

sequelize = new Sequelize('database', 'username', 'password',
  dialect: 'sqlite'
  storage: 'database.sqlite'
)

User = require('./user')(sequelize)

module.exports =
  User: User
  init: (cb) ->
    sequelize.sync().done cb