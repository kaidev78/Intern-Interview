import React from 'react'
const uuid = require('react-uuid')

class CreateRoomForm extends React.Component{

    constructor(props){
        super(props)
        this.state = {
            roomName: ""
        }
    }

    fieldChange = (e) => {
        this.setState({[e.target.name]: e.target.value})
    }

    createNewRoom = () => {
        const socket = this.props.socket
        if(this.state.roomName.trim() == ""){
            console.log("Room name can't be empty")
            return
        }
        const room = {roomName: this.state.roomName, roomid: uuid()}
        socket.emit('createNewRoom', {room}, () => {
            this.props.appendRoomList(room)
        })
        this.props.switchCreate()
    }

    render(){
        return(
            <div className="createRoomForm" style={{display: this.props.create?"flex":"none"}}>
                <div className="createRoomTitle">Create Your Room</div>
                <input className="createRoomInput" type="text" name="roomName" onChange={this.fieldChange}></input>
                <button className="createButton" onClick={this.createNewRoom}>Create</button>
            </div>
        )
    }
}

export default CreateRoomForm