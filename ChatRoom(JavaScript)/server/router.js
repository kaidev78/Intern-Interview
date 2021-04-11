const express = require('express')
const router = express.Router();
const { getRooms } = require('./rooms')
const { getRoomMessages } = require('./messages')

router.get('/', (req, res) => {
    res.send('server is running');
})

router.get('/rooms', (req, res) => {
    res.json({rooms: getRooms()})
})

router.get('/:roomid', (req, res) => {
    res.json({messageList: getRoomMessages(req.params.roomid)})
})

module.exports = router;