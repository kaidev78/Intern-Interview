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

const initialState = {
    token: localStorage.getItem('token'),
    isAuthenticated: false,
    isLoading: false,
    user: null,
    totalAccumulated: null,
    registerSucess: false,
    usersTAC: [],
    msg: ""
};


export default function(state = initialState, action){
    switch(action.type){
        case USER_LOADING:
            return{
            ...state,
            isLoading: true
        };
        case USER_LOADED:
            return{
              ...state,
              isAuthenticated: true,
              isLoading: false,
              user: action.payload
          };
        case REGISTER_SUCCESS:
            return{
                ...state,
                registerSucess: true
            }
        case LOGIN_SUCCESS:
            localStorage.setItem('token', action.payload.token)
            return{
                ...state,
                ...action.payload,
                totalAccumulated: action.payload.totalAccumulated,
                isAuthenticated: true,
                isLoading: false
            };
            case AUTH_ERROR:
            case LOGIN_FAIL:
                console.log("Login Fail")
            case LOGOUT_SUCCESS:
            case REGISTER_FAIL:
                localStorage.removeItem('token');
                return{
                    ...state,
                    token: null,
                    user: null,
                    isAuthenticated: false,
                    isLoading: false
                }
            case USER_UPDATE:
                return{
                    ...state,
                    user: action.payload,
                    totalAccumulated: action.payload.user.totalAccumulated
                }
            case GET_USERS_TOTAL_ACC:
                return{
                    ...state,
                    usersTAC: action.payload
                }
            case CHANGE_USER_PASSWORD:
                console.log(action.payload)
                return{
                    ...state,
                    msg: action.payload.msg
                }
            default:
                return state

    }
  }