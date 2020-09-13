import React, { Component } from 'react';
import { Button, Container } from 'reactstrap';
import {getTimerRecord, updateTimerRecord, addTimerRecord} from '../actions/timerAction'
import {updateItem, getItem} from '../actions/timerlistAction'
import { loadUser } from '../actions/accountAction'
import {updateUserInfo} from '../actions/accountAction'
import { connect } from 'react-redux';
import AppNavbar from './AppNavbar'
import { Link } from 'react-router-dom';
var dateFormat = require('dateformat')
const jwtdecode = require('jwt-decode');

class Timer extends Component{
    constructor(props){
        super(props)
        this.timer = null;
        this.state = {
            startTime: 0,
            startAt: -1,
            count: 0,
            totalAccumulated: 0,
            accumulatedCount: 0,
            startdiable: false,
            stopdiable: true,
            resetdiable: true,
            update: true,
            firstload: true
        }
    }

    startCounting = () => {
        this.setState({count: this.state.count + 1, startAt: this.state.startAt + 1,accumulatedCount: this.state.accumulatedCount + 1 })
    }
    
    startTimer = () => {
        if(this.timer == null){
            return
        }
        this.myInterval = setInterval(this.startCounting ,1000)
        this.setState({stopdiable: false, startdiable: true, resetdiable: true})
    }

    stopTimer = () => {
        if(this.timer == null){
            return
        }
        clearInterval(this.myInterval)
        var tc = this.state.totalAccumulated;
        tc += this.state.accumulatedCount
        var userUpdate = {id: this.user_id, totalAccumulated: tc}
        var today = dateFormat(Date(), "yyyy-mm-dd")
        var updateTimer = {
            id: this.timer._id,
            timername: this.timer.timername,
            mostRecentupdate: today,
            accumulatedTime: this.state.startAt
        }
        if(this.timer.mostRecentupdate == null || this.timer.mostRecentupdate !== today){
            var record = {parentId: this.timer._id, date: today ,todayTime: this.state.startAt}
            this.props.addTimerRecord(record)
            console.log("add")
        }
        else{
            var record = {parentId: this.timer._id, date: today, todayTime: this.state.startAt}
            this.props.updateTimerRecord(record)
            console.log("update")
        }
        this.props.updateItem(updateTimer)
        this.props.updateUserInfo(userUpdate)
        
        localStorage.setItem('totalAccumulated', tc)
        localStorage.setItem('accumulatedTime', this.state.startAt)
        this.setState({startdiable: false, resetdiable: false, stopdiable: true, update: true})
    }

    resetTimer = () => {
        this.setState({resetdiable: true, count: 0})
    }

    componentWillMount(){
        if(this.props.location.state == null){
            this.setState({startdiable: true, stopdiable: true, resetdiable: true})
            return
        }
        //GET USER ID
        const token = localStorage.getItem('token');
        this.user_id = jwtdecode(token)['id'];
        this.timername = this.props.location.state.timer.timername;
        var timerId = this.props.location.state.timer._id
        var accountId = this.props.location.state.accountId;
        this.props.getItem(timerId)
        this.props.loadUser(accountId)
    }


    componentWillUnmount(){
        clearInterval(this.myInterval)
    }
    
    componentDidUpdate(prevProp, prevState){
        if(this.state.update){
            this.timer = this.props.timerlist.item
        }
        if(this.state.firstload){
            var startAt = parseInt(localStorage.getItem("accumulatedTime"))
            var totalAccumulated = parseInt(localStorage.getItem("totalAccumulated"))
            if(prevState && (startAt != prevState.startAt || totalAccumulated != prevState.totalAccumulated) && this.state.update){
                this.setState({startAt: startAt, totalAccumulated: totalAccumulated, update: false, firstload: false })
            }
        }

        if(this.timer == null && !this.state.startdiable && !this.state.stopdiable && !this.state.resetdiable){
            console.log("Protective Mechanism")
            this.setState({startdiable: true, stopdiable: true, resetdiable: true})
        }
    }

    toHHMMSS = function (sec) {
        var sec_num = parseInt(sec, 10);
        var hours   = Math.floor(sec_num / 3600);
        var minutes = Math.floor((sec_num - (hours * 3600)) / 60);
        var seconds = sec_num - (hours * 3600) - (minutes * 60);

        if (hours   < 10) {hours   = "0"+hours;}
        if (minutes < 10) {minutes = "0"+minutes;}
        if (seconds < 10) {seconds = "0"+seconds;}
        return hours+':'+minutes+':'+seconds;
    }

    render(){
        if(localStorage.getItem("token") == null){
            return <div> <Link to={{pathname:"/"}}>Log In Before Visit</Link></div>
        }

        return(
            <div>
                <AppNavbar/>
                <Container>
                    <div style={{fontWeight:"bold", fontSize:"3em"}}>{this.timername}</div>
                    <div style={{marginTop:"20px"}}>Accumulated Time: {this.toHHMMSS(this.state.startAt)}</div>
                    <div style={{marginTop:"20px", fontSize:"25px"}}>Time has passed: {this.toHHMMSS(this.state.count)}</div>
                    <div style={{marginTop:"20px"}}>
                        <Button className="btn btn-success" disabled={this.state.startdiable} style={{marginRight:"10px"}} onClick={this.startTimer}>Start</Button>
                        <Button className="btn btn-danger"  disabled={this.state.stopdiable} style={{marginRight:"10px"}} onClick={this.stopTimer}>Stop</Button>
                        <Button className="btn btn-warning" disabled={this.state.resetdiable} style={{marginRight:"10px"}} onClick={this.resetTimer}>Reset</Button>
                    </div>
                </Container>
            </div>
        )
    }
}

const mapStateToProps = (state) => ({
    isAuthenticated: state.authentication.isAuthenticated,
    error: state.error,
    timerlist: state.timerlist
})

export default connect(mapStateToProps, { getTimerRecord, updateTimerRecord, addTimerRecord,
     updateItem, getItem, updateUserInfo, loadUser})(Timer);