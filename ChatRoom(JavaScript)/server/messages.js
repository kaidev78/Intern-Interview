var messages = []

addMessagesList = (roomid) => {
    console.log("created a new message list")
    messages[roomid] = []
}

addMessages = (roomid, socketid,message) => {
    messages[roomid].push({user: socketid, text: message})
}

getMessages = (room) => {
    return messages[room]
}

getRoomMessages = (roomid) => {
    return messages[roomid]
}

module.exports = {addMessages, getMessages, addMessagesList, getRoomMessages}