var users = []

const addUser = ({id, name, roomName}) => {
    name = name.trim().toLowerCase();
    roomName = roomName.trim().toLowerCase();

    const existed = users.find(user => user.room === room && user.name === name)

    if(existed){
        return {error: "Room is taken"}
    }

    const user = {id, name, room}
    users.push(user)
    return{user}
}

const removeUser = (id) => {
    users = users.filter(user => user.id != id)
}

const getUser = (id) => users.find((user) => user.id === id)


const getUsersInRoom = (room) => users.filter((user) => user.room === room)

module.exports = {addUser, removeUser, getUser, getUsersInRoom}