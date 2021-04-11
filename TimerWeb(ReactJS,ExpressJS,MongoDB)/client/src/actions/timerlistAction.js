import {UPDATE_TIMER, GET_TIMER, TIMER_LOADING, TIMER_LOADED, DELETE_TIMER, DELETE_TIMERS, GET_TIMERS, ADD_TIMER, UPDATE_TIMER_NAME} from './types';
import axios from 'axios'
import { tokenConfig } from './accountAction';
import { returnErrors } from './errorAction';
import { compareSync } from 'bcryptjs';

export const  getItems = () => (dispatch, getState) => {
    dispatch(setItemsLoading());
    axios.get('/api/timer', tokenConfig(getState))
    .then(res => {
        dispatch({
            type: GET_TIMERS,
            payload: res.data
        })
    }).catch(err => dispatch(returnErrors(err.response.data, err.response.status)));
}

export const getItem = (id) => (dispatch, getState) => {
    axios.get(`/api/timer/${id}`, tokenConfig(getState))
    .then(res => {
        localStorage.setItem('accumulatedTime',  res.data.accumulatedTime)
        dispatch({
            type: GET_TIMER,
            payload: res.data
        })
    })
}

export const deleteItems = (id) => (dispatch, getState) => {
    axios.delete(`/api/timer/${id}`, tokenConfig(getState)).then(
        res => {
            dispatch({
                type: DELETE_TIMER,
                payload: id
            })
        }
    ).catch(err => dispatch(returnErrors(err.response.data, err.response.status)))
}

export const addItems = (item) => (dispatch, getState) => {
    axios.post('/api/timer', item, tokenConfig(getState))
    .then(res => 
        dispatch({
            type: ADD_TIMER,
            payload: res.data
        }))
    .catch(err => dispatch(returnErrors(err.response.data, err.response.status)))
}

export const updateItem = ({id, timername, mostRecentupdate, accumulatedTime}) => (dispatch, getState) => {

    const body = JSON.stringify({timername, mostRecentupdate, accumulatedTime});

    axios.post(`/api/timer/update/${id}`, body, tokenConfig(getState))
    .then(res => dispatch({
        type: UPDATE_TIMER,
        payload: res.data
    }))
}

export const updateItemName = ({id, timername, mostRecentupdate, accumulatedTime}) => (dispatch, getState) => {

    const body = JSON.stringify({timername, mostRecentupdate, accumulatedTime});

    axios.post(`/api/timer/update/${id}`, body, tokenConfig(getState))
    .then(res => dispatch({
        type: UPDATE_TIMER_NAME,
        payload: res.data
    }))
}

export const setItemsLoading = () => {
    return {
        type: TIMER_LOADING
    }
}

