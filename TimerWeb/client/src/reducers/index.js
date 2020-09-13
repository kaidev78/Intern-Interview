import { combineReducers } from 'redux'
import accountreducer from './accountrd'
import errorreducer from './errorrd'
import timerlistreducer from './timerlistrd'
import timerecordreducer from './timerrecordrd'

export default combineReducers({
    authentication: accountreducer,
    error: errorreducer,
    timerlist: timerlistreducer,
    record: timerecordreducer
});