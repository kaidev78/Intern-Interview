import React, { Component } from 'react';
import { Link } from 'react-router-dom';
import { connect } from 'react-redux';
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
  import { logout } from '../actions/accountAction';

  class AppNavbar extends Component{
    
    state = {
        isOpen: false
    }

    toogle = () => {
      this.setState({
          isOpen: !this.state.isOpen
      });
    }

    
    logout = () => {
        this.props.logout();
    }

    render(){
        return(
        <div>
            <Navbar color="dark" dark expand="sm" className="mb-5">
                <Container>
                    <NavbarBrand>NianTimerWeb</NavbarBrand>
                    <NavbarToggler onClick={this.toogle}/>
                    <Collapse isOpen={this.state.isOpen} navbar>
                        <Nav className="ml-auto" navbar>

                            <NavItem>
                                    <NavLink href='/setting'>
                                    Setting
                                    </NavLink>
                            </NavItem>

                            <NavItem>
                                    <NavLink href='/ranking'>
                                    Ranking
                                    </NavLink>
                            </NavItem>

                            <NavItem>
                                    <NavLink href="/timerlist">
                                    List
                                    </NavLink>
                            </NavItem>

                            <NavItem>
                                    <NavLink onClick={this.logout} href="/">
                                    Logout
                                    </NavLink>
                            </NavItem>

                        </Nav>
                    </Collapse>
                </Container>
            </Navbar>
        </div>
        )
    }
  }


  const mapStateToProps = (state) => ({})
export default connect(mapStateToProps, { logout })(AppNavbar)