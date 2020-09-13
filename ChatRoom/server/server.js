const express = require('express')
const socketio = require('socket.io')
const http = require('http')
const cors = require('cors')

const PORT = process.env.PORT || 3000

const router = require('./router')
const { addUser, getUser } = require('./users')
const { addRoom, getRooms } = require('./rooms')
const { addMessages, getMessages, addMessagesList} = require('./messages')


const app = express()
const server = http.createServer(app)
const io = socketio(server)

app.use(cors())

io.on('connection', (socket) => {

    //Join Room
    socket.on('join', ({room, userName}, callback) => {

        console.log(`User ${userName} join room ${room.roomName} with id ${room.roomid}`)
        //const{error, user} = addUser(socket.id, "tester", room)
        
        // if(error)return callback(error)

        // socket.broadcast.to(user.room).emit('message', {user: 'admin', text: `${user.name}, has joined`})

        socket.join(room.roomid)

        socket.broadcast.to(room.roomid).emit('message', { user: "ADMIN", text: `user ${userName} has joined!` });

        //callback();
    })

    //Leave Room
    socket.on('leave', ({room, userName}, callback) => {

        socket.leave(room.roomid)

        console.log(`user ${userName} leaves room ${room.roomName} with id ${room.roomid}`)

    })

    //Send message
    socket.on('sendMessage', ({message, room, userName}, callback) => {
        //const user = getUser(socket.id)
        console.log(`message ${message} sent from ${room.roomName} by ${userName}`)

        io.to(room.roomid).emit('message', {user: userName, text: message})

        console.log(`MESSAGE ${message} added to ${room.roomid}`)
        addMessages(room.roomid, userName, message)
        
        //callback()
    })

    //New Room Created
    socket.on('createNewRoom', ({room}, callback) => {
        console.log(`create new room ${room.roomName} with roomid ${room.roomid} `)
        addRoom(room)
        addMessagesList(room.roomid)
        socket.broadcast.emit('addNewRoom', {room})
        callback()
    })

    //Disconnect
    socket.on('disconnect', () => {
        console.log("A user left the room")
    })

    console.log(`A user ${socket.id} has joined`)
})

app.use(router) 

server.listen(PORT, () => console.log(`Server has started on port ${PORT}`))