import React, { Component } from 'react';
import 'bootstrap/dist/css/bootstrap.min.css';
import { changeUserName, changeUserPassword } from '../actions/accountAction'
import { connect } from 'react-redux';
import {
    Container,
    Alert
  } from 'reactstrap';
  import AppNavbar from './AppNavbar'
  import { Link } from 'react-router-dom';
  const jwtdecode = require('jwt-decode');

  class Settings extends Component{

    state = {
        password: "",
        password2: "",
        name: "",
        msg: ""
    }

    onSubmitChangePassword = (e)=> {
        e.preventDefault()
        if(this.state.password !== this.state.password2){
            this.setState({msg: "Password Doesn't Match"})
            return
        }
        else{
            this.setState({msg: ""})
        }
        const token = localStorage.getItem('token');
        this.user_id = jwtdecode(token)['id'];
        var user = {id: this.user_id, password: this.state.password}
        this.props.changeUserPassword(user)
    }

    onSubmitChangeName = (e)=> {
        e.preventDefault()
        const token = localStorage.getItem('token');
        this.user_id = jwtdecode(token)['id'];
        var user = {id: this.user_id, name: this.state.name}
        this.props.changeUserName(user)
    }

    onChange = e => {
        this.setState({[e.target.name]: e.target.value});
    }

    render(){

        if(localStorage.getItem("token") == null){
            return <div> <Link to={{pathname:"/"}}>Log In Before Visit</Link></div>
        }

        return(
            <div>
                <AppNavbar/>
                <Container>
                <form className="form-signin" onSubmit={this.onSubmitChangePassword} >
                    {this.state.msg ? <Alert color="danger">{this.state.msg}</Alert> : null}
                    {this.props.message ? <Alert color="success">{this.props.message}</Alert> : null}
                    <h1 className="h3 mb-3 font-weight-normal">Change Password Here</h1>
                    <input type="password" id="inputPassword" className="form-control" placeholder="Password" name="password"  onChange={this.onChange} required/>
                    <input type="password" id="inputPassword2" className="form-control" placeholder="Enter Password Again" name="password2" onChange={this.onChange} required/>
                    <button className="btn btn-lg btn-primary btn-block" type="submit">Change Password</button>
                </form>
                <div>----------------------------------------------------------------------------------------------------------------------------------------</div>
                <form className="form-signin" onSubmit={this.onSubmitChangeName} >
                    <h1 className="h3 mb-3 font-weight-normal">Change Your Name Here</h1>
                    <input type="name" id="inputName" className="form-control" placeholder="New Name" name="name"  onChange={this.onChange} required/>
                    <button className="btn btn-lg btn-primary   btn-block" type="submit">Change Name</button>
                </form>
                </Container>
            </div>
        )
    }
  }

  const mapStateToProps = (state) => ({
    message: state.authentication.msg
})

export default connect(mapStateToProps, { changeUserName, changeUserPassword })(Settings);