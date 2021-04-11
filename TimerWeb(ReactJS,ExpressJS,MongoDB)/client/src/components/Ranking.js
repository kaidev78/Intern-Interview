import React, { Component } from 'react';
import 'bootstrap/dist/css/bootstrap.min.css';
import { getTotalTimes } from '../actions/accountAction'
import { connect } from 'react-redux';
import {
    Container,
    ListGroup,
    ListGroupItem
  } from 'reactstrap';
  import AppNavbar from './AppNavbar'
  import { Link } from 'react-router-dom';
  class Ranking extends Component{

    componentWillMount(){
        this.props.getTotalTimes()
    }

    render(){

        if(localStorage.getItem("token") == null){
            return <div> <Link to={{pathname:"/"}}>Log In Before Visit</Link></div>
        }

        var ranking = this.props.ranking

        return(
            <div>
                <AppNavbar/>
                <div style={{fontWeight:"bold", fontSize:"2em"}}>Rankings</div>
                <Container style={{marginTop:"20px"}}>
                    <ListGroup>
                        {ranking.map( (user, index) => {
                            return(
                                <ListGroupItem>
                                    <span className="float-left">{index + 1}. {user.name}</span>
                                    <span  className="float-right">{(user.totalAccumulated/3600).toFixed(2)} hours</span>
                                </ListGroupItem>
                            )
                        })}
                    </ListGroup>
                </Container>
            </div>
        )
    }

  }

  const mapStateToProps = (state) => ({
    ranking: state.authentication.usersTAC
})

export default connect(mapStateToProps, { getTotalTimes })(Ranking);