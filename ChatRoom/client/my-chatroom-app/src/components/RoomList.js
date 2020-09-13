import React from 'react'
import { Link } from 'react-router-dom'
const axios = require('axios')

class RoomList extends React.Component{

    constructor(props){
        super(props)
    }


    enterChatRoom = (room) => {
        if(this.props.currentRoom != null){
            this.props.socket.emit('leave', {room: this.props.currentRoom, userName: this.props.name})
        }
        this.props.selectARoom(room)
        this.props.socket.emit('join', {room, userName: this.props.name})
        this.props.loadRoomMessages(room)
    }

    componentDidMount(){
        // axios.get('http://localhost:3000/rooms')
        // .then(data => {
        //     console.log(data.data.rooms)
        //     this.setState({roomlist: data.data.rooms})
        // })
        // const socket = this.props.socket
        // console.log(this.props)
        // socket.on('addNewRoom', ({newroom}) => {
        //     console.log(`new room ${newroom.roomName} with id ${newroom.roomid} is created from other user`)
        //     this.setState({roomlist: [...this.state.roomlist, newroom]})
        // })
    }

    render(){
        return(
            <div className="roomList">
                <div className="roomtitle">RoomList</div>
                {this.props.roomList.map(room => {
                    return(
                        <div className="room" onClick={() => this.enterChatRoom(room)}>
                            <Link to={{pathname:"/", state:{pickChatRoom: room}}}>{room.roomName}</Link>
                        </div>
                    )
                })}
            </div>
        )
    }
}

export default RoomList