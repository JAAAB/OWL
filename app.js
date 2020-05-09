//loading our app server
const express = require('express')
const app = express()

app.get("/", (req, res) => {
	console.log("Responding to root route");
	res.send("This is the root route");
})

app.get("/users", (req, res) => {
	res.send("Users route");
})




var portNum = 3003;

app.listen(portNum, () => {
	console.log("Server up on port " + portNum)
})


