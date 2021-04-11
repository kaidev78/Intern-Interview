import { 
    LOGIN_SUCCESS,
    LOGIN_FAIL,
    LOGOUT_SUCCESS,
    REGISTER_SUCCESS,
    REGISTER_FAIL,
    USER_LOADED,
    USER_LOADING,
    AUTH_ERROR,
    USER_UPDATE,
    GET_USERS_TOTAL_ACC,
    CHANGE_USER_PASSWORD
} from '../actions/types';
import axios from 'axios';
import { returnErrors } from './errorAction'
const bcrypt = require('bcryptjs');

export const login = ({username, password}) => dispatch => {
    const config = {
        headers: {
            "Content-type": "application/json"
        }
    }
    //request body 
    const body = JSON.stringify({username, password});

    axios.post('/api/user/login', body, config)
    .then(res => dispatch({
        type: LOGIN_SUCCESS,
        payload: res.data
    }))
    .catch(err => {
        dispatch(returnErrors(err.response.data, err.response.status, 'LOGIN_FAIL'));
        dispatch({type: LOGIN_FAIL});
    });
  }

// Logout User
export const logout = () => {
    return {
      type: LOGOUT_SUCCESS
    };
  };

export const tokenConfig = (getState) => {
        // Get token from localstorage
        const token = getState().authentication.token;

        const config = {
            headers: {
                "Content-type": "application/json"
            }
        }

        if(token){
            config.headers['x-auth-token'] = token;
        }
        
        return config;
  }

  export const loadUser = (id) => (dispatch, getState) => {
    axios.get(`/api/user/${id}`, tokenConfig(getState))
    .then(
        res => {
            localStorage.setItem('totalAccumulated', res.data.user.totalAccumulated)
            dispatch(
                {
                    type: USER_LOADED,
                    payload: res.data
                }
            )
        }
    )
  }

  export const updateUserInfo = ({id,totalAccumulated}) => (dispatch, getState) => {
      const body = JSON.stringify({totalAccumulated})
      axios.post(`/api/user/${id}/updateinfo`, body, tokenConfig(getState))
      .then(
          res => {
              dispatch(
                  {
                      type: USER_UPDATE,
                      payload: res.data
                  }
              )
          }
      )
  }

//Register User
export const register = ({ username, password, name, totalAccumulated}) => (
    dispatch
  ) => {
    // Headers
    const config = {
      headers: {
        'Content-Type': 'application/json'
      }
    };
  
    // Request body
    const body = JSON.stringify({ username, password, name, totalAccumulated });
  
    axios
      .post('/api/user/register', body, config)
      .then(res =>
        dispatch({
          type: REGISTER_SUCCESS,
          payload: res.data
        })
      )
      .catch(err => {
        console.log(err.response.data)
        dispatch(
          returnErrors(err.response.data, err.response.status, 'REGISTER_FAIL')
        );
        dispatch({
          type: REGISTER_FAIL
        });
      });
  };

  //Get Users Total Time
  export const getTotalTimes = () => (dispatch, getState) => {
      axios.post('/api/user/accumulatedtimes', {}, tokenConfig(getState))
      .then(res => {
          dispatch({
              type: GET_USERS_TOTAL_ACC,
              payload: res.data
          })
      })
  }

  //Chaneg User Name
  export const changeUserName = ({id, name}) => (dispatch, getState) => {
    const body = JSON.stringify({name});
    axios.post(`/api/user/${id}/updatename`, body, tokenConfig(getState))
  }

//Chaneg User Password
export const changeUserPassword = ({id, password}) => (dispatch, getState) => {
    const body = JSON.stringify({password});
    axios.post(`/api/user/${id}/updatepassword`, body, tokenConfig(getState)).then(
        res => dispatch({
            type: CHANGE_USER_PASSWORD,
            payload: res.data
        })
    )
}