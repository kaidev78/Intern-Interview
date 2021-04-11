import { GET_TIMERS, TIMER_LOADING, ADD_TIMER, DELETE_TIMER, GET_TIMER, UPDATE_TIMER, UPDATE_TIMER_NAME } from '../actions/types';

const initialState = {
    items: [],
    item: null,
    loading: false
};
export default function(state = initialState, action){
    switch(action.type){
        case GET_TIMERS:
            return{
                ...state,
                items: action.payload,
                loading: false
            }
        case TIMER_LOADING:
            return{
                ...state,
                loading: true
            }
        case ADD_TIMER:
            return{
                ...state,
                items: [...state.items,action.payload]
            }
        case DELETE_TIMER:
            return {
                ...state,
                items: state.items.filter(item => item._id !== action.payload)
            }
        case GET_TIMER:
            return{
                ...state,
                item: action.payload
            }
        case UPDATE_TIMER:
            return{
                ...state,
                item: action.payload.timer
            }
        case UPDATE_TIMER_NAME:
            return{
                ...state,
                items: state.items.map(item => {
                    if(item._id == action.payload.timer._id){
                        item.timername = action.payload.timer.timername
                        return item
                    }
                    else{
                        return item
                    }
                })
            }
        default:
            return state;
    }
}