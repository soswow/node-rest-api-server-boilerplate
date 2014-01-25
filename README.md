How to get started
------------------
Copy and execute this in folder you want your project to be in.
```
git clone https://github.com/soswow/node-rest-api-server-boilerplate.git .tmp --single-branch --branch master &&
cp -R .tmp/ . && rm -rf .tmp README.md .git &&
npm install
```

After then you should un-underscore file ```app/_secrets.coffee``` and write all your secrets.
Then run server with ```coffee app/server.coffee```