import React, { Component } from 'react';
import 'bootstrap/dist/css/bootstrap.min.css';
import { connect } from 'react-redux';
import { login } from '../actions/accountAction';
import { clearErrors } from '../actions/errorAction';
import {Alert} from 'reactstrap'
import { Redirect } from 'react-router-dom'
import { Link } from 'react-router-dom';
import {
    Collapse,
    Navbar,
    NavbarToggler,
    NavbarBrand,
    Nav,
    Container
  } from 'reactstrap';

  class Login extends Component{

    state = {
        username: '',
        password: '',
        msg: null
    }

    onChange = e => {
        this.setState({[e.target.name]: e.target.value});
    }

    onSubmit = e => {
        e.preventDefault();
        const {username, password} = this.state;
        const user = {username, password};
        this.props.login(user);
    }

    componentDidUpdate(prevProp){
        const {error} = this.props;
        if(error !== prevProp.error){
            this.setState({msg: error.msg.msg});
        }
    }

    directToRegister = () => {
        return <Redirect to={{pathname: '/register'}}/>
    }

    render(){

        if(this.props.isAuthenticated){
            return <Redirect to={{pathname: '/timerlist'}}/>
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
                    <h1 className="h3 mb-3 font-weight-normal">Log In</h1>
                    <input type="username" id="inputUsername" className="form-control" placeholder="Username" name="username"  onChange={this.onChange} required autoFocus/>
                    <input type="password" id="inputPassword" className="form-control" placeholder="Password" name="password" onChange={this.onChange} required/>
                    <div className="checkbox mb-3">
                    {/* <label>
                        <input type="checkbox" value="remember-me"/> Remember me
                    </label> */}
                    </div>
                    <button className="btn btn-lg btn-primary btn-block" type="submit">登录</button>
                    <Link to={{pathname:"/register"}}>register</Link>
                </form>
           </div>
        )
    }
  }

const mapStateToProps = (state) => ({
    isAuthenticated: state.authentication.isAuthenticated,
    error: state.error,
    user: state.authentication
})

export default connect(mapStateToProps, { login, clearErrors })(Login);