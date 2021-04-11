import React from 'react'

class MessageList extends React.Component{

    constructor(props){
        super(props)
    }

    componentWillMount(){
        if(this.props.currentRoom != null){
            console.log("LOAD MESSAGES")
        }

        // this.props.socket.on('message', ({user, text}) => {
        //     var message = {user, text}
        //     this.setState({messageList: [...this.state.messageList, message]})
        //     console.log(`recirved messages ${text} from ${user}`)
        // })
    }

    render(){
        if(this.props.currentRoom == null){
            return(<div className="messageList"><span className="selectRoomAlarm">Please Select A Chat Room From The List</span></div>)
        }
        return(
            <div className="messageList">
                {this.props.messageList.map(message => {
                    return(<div>{message.user}: {message.text} </div>)
                })}
            </div>
        )
    }
}

export default MessageList