import React from 'react'

class NewRoomForm extends React.Component{
    render(){
        return(
            <button className="newRoomForm"  onClick={this.props.switchCreate}>
                Create New Room
            </button>
        )
    }
}

export default NewRoomForm