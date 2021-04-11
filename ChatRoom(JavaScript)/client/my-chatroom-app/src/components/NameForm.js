import React from 'react'

class NameForm extends React.Component{

    constructor(props){
        super(props)
        this.state = {
            userName: ""
        }
    }

    fieldChange = (e) => {
        this.setState({[e.target.name]: e.target.value})
    }

    submitName = () => {
        if(this.state.userName.trim() == ""){
            console.log("You can't leave your name empty")
            return
        }

        this.props.getName(this.state.userName)
        this.props.displayGetNameWindow()
        console.log(`Your name is ${this.state.userName}`)
    }

    render(){
        return(
            <div className="nameForm" style={{display: this.props.addname?"flex":"none"}}>
                <div className="addNameTitle">Please Enter Random Name!</div>
                <input className="addNameInput" type="text" name="userName" onChange={this.fieldChange} required></input>
                <button className="nameSubmitButton" onClick={this.submitName}>Submmit</button>
            </div>
           
        )
    }
}

export default NameForm