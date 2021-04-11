import React from 'react';
import './App.css';
import RoomList from './components/RoomList'
import MessageList from './components/MessageList'
import NewRoomForm from './components/NewRoomForm'
import SendMessageForm from './components/SendMessageForm'
import CreateRoomForm from './components/RoomCreate'
import NameForm from './components/NameForm'
import io from 'socket.io-client'
import {BrowserRouter as Router, Route} from 'react-router-dom'
const ENDPOINT = 'http://localhost:3000'
const axios = require('axios')
class App extends React.Component {

  constructor(props){
    super(props)
    this.state = {
      name: "",
      room: "",
      roomList: [],
      messageList: [],
      currentRoom: null,
      create: false,
      addname: true
    }
    this.socket = ""
  }

  displayCreateWindow = () => {
    this.setState({create: !this.state.create})
  }

  displayGetNameWindow = () => {
    this.setState({addname: !this.state.addname})
  }

  appendRoomList = (newRoom) =>{
    this.setState({roomList: [...this.state.roomList, newRoom]})
  }

  selectARoom = (room) => {
    console.log("room selected")
    this.setState({currentRoom: room})
  }

  getName = (name) => {
    this.setState({name: name})
  }

  loadRoomMessages = (room) => {
    axios.get(`http://localhost:3000/${room.roomid}`)
    .then(data => {
      console.log(data)
      this.setState({messageList: data.data.messageList})
    })
  }

  componentWillMount(){
    this.socket = io(ENDPOINT)

    axios.get('http://localhost:3000/rooms')
    .then(data => {
        console.log(data.data.rooms)
        this.setState({roomList: data.data.rooms})
    })

    this.socket.on('addNewRoom', ({room}) => {
        console.log(`new room ${room.roomName} with id ${room.roomid} is created from other user`)
        this.setState({roomList: [...this.state.roomList, room]})
    })

    this.socket.on('message', ({user, text}) => {
      var message = {user, text}
      this.setState({messageList: [...this.state.messageList, message]})
      console.log(`recirved messages ${text} from ${user}`)
  })

  }

  render(){
    return (
      <Router>
        <div className="App">

          <NameForm
          addname = {this.state.addname}
          getName = {this.getName}
          displayGetNameWindow = {this.displayGetNameWindow}
          />

            <CreateRoomForm 
            create = {this.state.create}
            socket = {this.socket}
            switchCreate = {this.displayCreateWindow}
            appendRoomList = {this.appendRoomList}
            name = {this.state.name}/>

            <RoomList
            socket = {this.socket}
            roomList = {this.state.roomList}
            switchCreate = {this.displayCreateWindow}
            selectARoom = {this.selectARoom}
            currentRoom = {this.state.currentRoom}
            loadRoomMessages = {this.loadRoomMessages}
            name = {this.state.name}
            />

            <MessageList
            socket = {this.socket}
            currentRoom = {this.state.currentRoom}
            messageList = {this.state.messageList}
            />

            <NewRoomForm 
            switchCreate = {this.displayCreateWindow}/>

            <SendMessageForm
            socket = {this.socket}
            currentRoom = {this.state.currentRoom}
            name = {this.state.name}/>

        </div>
      </Router>
    );
  }
}

export default App;
