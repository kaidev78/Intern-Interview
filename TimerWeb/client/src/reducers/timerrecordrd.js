import { TIMER_RECORD_LOADED, TIMER_RECORD_LOADING, GET_TIMER_RECORD } from '../actions/types'

const initialState = {
    records: [],
    loading: false
}

export default function(state = initialState, action){
    switch(action.type){
        case TIMER_RECORD_LOADING:
            return{
                ...state,
                loading: true
            }
        case GET_TIMER_RECORD:
            return{
                ...state,
                records: action.payload,
                loading: false
            }
        default:
            return state
    }
}