import React, { Component } from 'react';
import { getItems, addItems, deleteItems, updateItem, updateItemName } from '../actions/timerlistAction'; 
import { addTimerRecord, deleteTimerRecord } from '../actions/timerAction'
import { loadUser, updateUserInfo } from '../actions/accountAction'
import { Link } from 'react-router-dom';
import { connect } from 'react-redux';
import {Container, ListGroup, ListGroupItem, Button, Modal, ModalHeader, ModalBody, ModalFooter} from 'reactstrap';
import AppNavbar from './AppNavbar'
const jwtdecode = require('jwt-decode');

class TimerList extends Component{

    state = {
        createPopup: false,
        editPopup: false,
        timername: "",
        totalAccumulated: 0,
        editTimer: null,
        editMode: false
    }

    createTimer = () => {
        console.log(this.state.timername)
        const newItem = {timername: this.state.timername}
        this.props.addItems(newItem)
        this.setState({createPopup: false})
    }

    openEditPopup = (timer) => {
        this.setState({editPopup: !this.state.editPopup, editTimer: timer})
    }

    editTimer = () => {
        var updateTimer = {
            id: this.state.editTimer._id,
            timername: this.state.timername,
            mostRecentupdate: this.state.editTimer.mostRecentupdate,
            accumulatedTime: this.state.editTimer.accumulatedTime
        }
        this.props.updateItemName(updateTimer)
        this.switchEditPopup()
        this.props.getItems()
    }

    switchEditPopup = () => {
        this.setState({editPopup: !this.state.editPopup})
    }

    deleteTimer = (id, accumulatedTime) => {
        this.props.deleteItems(id)
        var delteItem = {parentId: id}
        this.props.deleteTimerRecord(delteItem)
        var usertc = this.props.user.user.user.totalAccumulated
        usertc -= accumulatedTime
        var userId = this.props.user.user.user._id
        var updateUser = {id: userId, totalAccumulated: usertc}
        this.props.updateUserInfo(updateUser)
        localStorage.setItem('totalAccumulated', usertc)
    }

    onChange = e => {
        this.setState({[e.target.name]: e.target.value});
    }

    toggleCreate = () => {
        this.setState({
            createPopup: !this.state.createPopup
        })
    }

    editMode = () => {
       this.setState({editMode: !this.state.editMode})
    }

    componentWillMount(){
        if(localStorage.getItem('token')==null)return
        const token = localStorage.getItem('token');
        this.user_id = jwtdecode(token)['id'];
        this.props.getItems();
        this.props.loadUser(this.user_id)
    }

    render(){

        if(localStorage.getItem("token") == null){
            return <div> <Link to={{pathname:"/"}}>Log In Before Visit</Link></div>
        }


        var timers = this.props.timers
        var accumulatedTime = localStorage.getItem("totalAccumulated")
    

        return(
            <div>
                <AppNavbar/>
                <Container>
                    <div style={{fontWeight:"bold"}}>Total Accumulated Time: {(accumulatedTime/3600).toFixed(2)} hours</div>
                    <div className="float-right">
                        <div className="custom-control custom-switch">
                            <input type="checkbox" class="custom-control-input" id="customSwitch1" onClick={this.editMode}/>
                            <label class="custom-control-label" htmlFor="customSwitch1">Edit Mode</label>
                        </div>
                        <Button className="btn-success" style={{marginTop:"10px"}} onClick={this.toggleCreate}>Create</Button>
                    </div>
                    <ListGroup style={{marginTop:"80px"}}>
                        {timers.map((timer, index)=>( 
                            <ListGroupItem key={index}>
                                <Button
                                className="remove-btn float-left"
                                color="danger"
                                size="sm"
                                style={{marginRight: "10px", display: this.state.editMode?"block":"none"}}
                                onClick = {() => this.deleteTimer(timer._id, timer.accumulatedTime)}>
                                &times;</Button>
                                <Button
                                className="float-left"
                                color="info "
                                size="sm"
                                style={{marginRight: "10px", display: this.state.editMode?"block":"none"}}
                                onClick = {() => this.openEditPopup(timer)}>
                                Edit</Button>
                                <span className="float-left">{timer.timername}</span>
                                <span className="float-right">{(timer.accumulatedTime/(60*60)).toFixed(2)} hours</span>
                                <Link className="float-right" to={{pathname:"/timer", state:{timer: timer, accountId: this.user_id}}} style={{marginRight:"10px"}} >Start</Link>
                                <Link className="float-right" to={{pathname:"/graph", state:{timer: timer, accountId: this.user_id}}} style={{marginRight:"10px"}} >Graph</Link>    
                            </ListGroupItem>
                        ))}
                    </ListGroup>
                </Container>
                <Modal isOpen={this.state.createPopup}>
                    <ModalHeader>Create Timer</ModalHeader>
                    <ModalBody>
                    <input id="inputTimername" className="form-control" placeholder="Username" name="timername"  onChange={this.onChange} required autoFocus/>
                    </ModalBody>
                    <ModalFooter>
                        <Button onClick={this.createTimer}>Create</Button>
                    </ModalFooter>
                </Modal>
                <Modal isOpen={this.state.editPopup}>
                    <ModalHeader>Edit Timer</ModalHeader>
                    <ModalBody>
                    <input id="inputTimername" className="form-control" placeholder="Username" name="timername"  onChange={this.onChange} required autoFocus/>
                    </ModalBody>
                    <ModalFooter>
                        <Button onClick={this.editTimer}>Create</Button>
                        <Button onClick={this.switchEditPopup}>Close</Button>
                    </ModalFooter>
                </Modal>
            </div>
        )
    }
}

const mapStateToProps = (state) => ({
    timers: state.timerlist.items,
    isAuthenticated: state.authentication.isAuthenticated,
    user: state.authentication
})

export default connect(mapStateToProps, {getItems, addItems, deleteItems, deleteTimerRecord, loadUser, updateUserInfo, updateItem, updateItemName})(TimerList)