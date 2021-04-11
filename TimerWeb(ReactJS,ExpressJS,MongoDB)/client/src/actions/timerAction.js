import {ADD_TIMER_RECORD, GET_TIMER_RECORD, UPDATE_TIMER_RECORD, DELETE_TIMER_RECORD} from "../actions/types"
import axios from 'axios';
import { returnErrors } from './errorAction'
import { tokenConfig } from './accountAction';

export const getTimerRecord =  (parentId) => (dispatch, getState) => {
    axios.get(`/api/timerrecord/${parentId}`, tokenConfig(getState))
    .then(res => {
        dispatch({
            type: GET_TIMER_RECORD,
            payload: res.data
        })
    })
}

export const updateTimerRecord = ({parentId, date, todayTime}) => (dispatch, getState) => {
    const body = JSON.stringify({parentId, date, todayTime});

    axios.post("/api/timerrecord/update", body, tokenConfig(getState))
    .then(res => {
        dispatch({
            type: UPDATE_TIMER_RECORD
            // payload: res.data
        })
    })
}

//Add Timer Record
export const addTimerRecord = ({parentId, date, todayTime}) => (dispatch, getState) => {
    const body = JSON.stringify({parentId, date, todayTime});

    axios.post("/api/timerrecord", body, tokenConfig(getState))
    .then(res => {
        dispatch({
            type: ADD_TIMER_RECORD
        })
    })
}

//Delete Timer Record
export const deleteTimerRecord = ({parentId}) => (dispatch, getState) => {
    
    const body = JSON.stringify({parentId});

    axios.post("/api/timerrecord/delete", body, tokenConfig(getState)).then(
        res => {
            dispatch({
                type: DELETE_TIMER_RECORD
            })
        }
    )
}