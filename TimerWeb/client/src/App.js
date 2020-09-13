import React from 'react';
import './App.css';
import Login from './components/Login'
import TimerlistPage from './components/TimerList'
import TimerPage from './components/Timer'
import RegisterPage from './components/Register'
import TimerGraphPage from './components/TimerGraph'
import RankingPage from './components/Ranking'
import SettingPage from './components/Setting'
import { BrowserRouter as Router, Route } from 'react-router-dom';
import {Provider} from 'react-redux';
import store from './store'
import { CookiesProvider } from 'react-cookie';

function App() {
  return (
      <Provider store={store}>
        <Router>
        <div className="App">
          <Route exact path='/' component={Login}/>
          <Route exact path='/timerlist' component={TimerlistPage}/>
          <Route exact path='/timer' component={TimerPage}/>
          <Route exact path='/register' component={RegisterPage}/>
          <Route exact path='/graph' component={TimerGraphPage}/>
          <Route exact path='/ranking' component={RankingPage}/>
          <Route exact path='/setting' component={SettingPage}/>
        </div>
      </Router>
    </Provider>
  );
}

export default App;
