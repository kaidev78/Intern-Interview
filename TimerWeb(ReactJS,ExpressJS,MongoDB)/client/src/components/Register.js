import React, { Component } from 'react';
import 'bootstrap/dist/css/bootstrap.min.css';
import { connect } from 'react-redux';
import { clearErrors } from '../actions/errorAction';
import {register} from '../actions/accountAction'
import {Alert} from 'reactstrap'
import { Redirect } from 'react-router-dom'
import { Link } from 'react-router-dom';
import {
    Collapse,
    Navbar,
    NavbarToggler,
    NavbarBrand,
    Nav,
    NavItem,
    NavLink,
    UncontrolledDropdown,
    DropdownToggle,
    DropdownMenu,
    DropdownItem,
    NavbarText,
    Container
  } from 'reactstrap';

  class Register extends Component{

    state = {
        username: '',
        password: '',
        password2: '',
        name: '',
        totalAccumulated: 0,
        msg: null,
        suc: false
    }

    onChange = e => {
        this.setState({[e.target.name]: e.target.value});
    }

    onSubmit = e => {
        e.preventDefault();
        const {username, password, name, password2, totalAccumulated} = this.state;
        const user = {username, password, name, totalAccumulated};
        if(password !== password2){
            this.setState({msg: "password doesn't match"})
            return
        }
        this.props.register(user)
    }

    componentDidUpdate(prevProp){
        const {error} = this.props;
        if(error !== prevProp.error){
            this.setState({msg: error.msg.error});
        }
    }

    render(){

        if(this.props.auth.registerSucess){
            return <Redirect to={{pathname: '/'}}/>
        }

        return(
            <div className="App text-center">
                <div>
                    <Navbar color="dark" dark expand="sm" className="mb-5">
                        <Container>
                            <NavbarBrand>NianTimerWeb</NavbarBrand>
                            <NavbarToggler onClick={this.toogle}/>
                            <Collapse isOpen={this.state.isOpen} navbar>
                                <Nav className="ml-auto" navbar>
                                </Nav>
                            </Collapse>
                        </Container>
                    </Navbar>
                </div>
                {this.state.msg ? <Alert color="danger">{this.state.msg}</Alert> : null}
                <form className="form-signin" onSubmit={this.onSubmit} >
                    <h1 className="h3 mb-3 font-weight-normal">Register</h1>
                    <input type="name" id="name" className="form-control" placeholder="Any random name" name="name" onChange={this.onChange} required autoFocus/>
                    <input type="username" id="inputUsername" className="form-control" placeholder="Username" name="username"  onChange={this.onChange} required/>
                    <input type="password" id="inputPassword" className="form-control" placeholder="Password" name="password" onChange={this.onChange} required/>
                    <input type="password" id="inputPassword2" className="form-control" placeholder="Enter password again" name="password2" onChange={this.onChange} required/>
                    <button className="btn btn-lg btn-primary btn-block" type="submit">提交</button>
                    <Link to={{pathname:"/"}}>Back To Login</Link>
                </form>
           </div>
        )
    }
  }


const mapStateToProps = (state) => ({
    error: state.error,
    auth: state.authentication
})

export default connect(mapStateToProps, { register, clearErrors })(Register);