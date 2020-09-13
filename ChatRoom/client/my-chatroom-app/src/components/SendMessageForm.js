import React from 'react'

class SendMessageForm extends React.Component{

    constructor(props){
        super(props)
        this.state = {
            message: ""
        }
    }

    fieldChange = (e) => {
        this.setState({[e.target.name]: e.target.value})
    }

    sendMessage = (e) => {
        var code = e.keyCode ? e.keyCode : e.which

        if(code != 13)return
        
        if(this.props.currentRoom == null){
            console.log("No Chat Room Is Selected")
            return
        }
        
        if(code == 13){
            this.props.socket.emit("sendMessage", {message: this.state.message, room: this.props.currentRoom, userName: this.props.name})
            this.setState({message: ""})
        }
    }

    render(){
        return(
            <input type="text" className="SendMessageForm" name = "message" onChange={this.fieldChange} onKeyPress={this.sendMessage} value={this.state.message}>
            </input>
        )
    }
}

export default SendMessageForm