import React, {Component} from 'react';
import {Line} from 'react-chartjs-2';
import { getTimerRecord } from '../actions/timerAction'; 
import { connect } from 'react-redux';
import { Link } from 'react-router-dom';
import AppNavbar from './AppNavbar'
import { Container } from 'reactstrap';
var dateFormat = require('dateformat');


class TimerGraph extends Component{
  
   
    componentDidMount(){
        
    }

   componentWillMount(){
       if(this.props.location.state == null)return
       var timer = this.props.location.state.timer
       this.props.getTimerRecord(timer._id)
   }

    render(){
        if(localStorage.getItem("token") == null){
            return <div> <Link to={{pathname:"/"}}>Log In Before Visit</Link></div>
        }

        var i = 0;
        var labels  = [];
        var data = [];
        var databyday = [];
        var timeToday = [];
        var records = this.props.record.records

        for(i = 0; i< records.length; i++){
            var record =  records[i];
            var formatdate = dateFormat(record.date, "mmmm dS yyyy");
            labels.push(formatdate);
            var hours = (record.todayTime / (60 * 60)).toFixed(2);
            data.push(hours);
            if(i > 0){
                timeToday.push(data[i] - data[i-1]);
                databyday.push(data[i] - data[i-1]);
            }
            else{
                timeToday.push(data[i])
                databyday.push(data[i]);
            }
        }
        
        const chartData = {
            chartData: {
                labels: labels,
                datasets: [
                  {
                    label: '',
                    fill: false,
                    lineTension: 0.1,
                    backgroundColor: 'rgba(75,192,192,0.4)',
                    borderColor: 'rgba(75,192,192,1)',
                    borderCapStyle: 'butt',
                    borderDash: [],
                    borderDashOffset: 0.0,
                    borderJoinStyle: 'miter',
                    pointBorderColor: 'rgba(75,192,192,1)',
                    pointBackgroundColor: '#fff',
                    pointBorderWidth: 1,
                    pointHoverRadius: 5,
                    pointHoverBackgroundColor: 'rgba(75,192,192,1)',
                    pointHoverBorderColor: 'rgba(220,220,220,1)',
                    pointHoverBorderWidth: 2,
                    pointRadius: 1,
                    pointHitRadius: 10,
                    data: databyday
                  }
                ]
            }
        }

        return(
            <div>
                <AppNavbar/>
                <Container>
                    <Line data={chartData.chartData} width={900} height={250} 
                        options={{
                        scales: {
                            yAxes: [{
                            ticks: {
                                beginAtZero: true
                            }
                            }]
                        },
                        legend: {
                            display: false
                        }
                        }} />
                        <div className="table-responsive">
                            <table className="table table-striped table-sm">
                                <thead>
                                    <tr>
                                    <th>Date</th>
                                    <th>Time Of The Day(Hour)</th>
                                    <th>Accumulated Time(Hour)</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {
                                        records.map((record, index) => {return (
                                            <tr key={index}>
                                            <td>{record.date}</td>
                                            <td>{timeToday[index]}</td>
                                            <td>{data[index]}</td>
                                            </tr>
                                        )})
                                    }
                                </tbody>
                            </table>
                        </div>
                </Container>
            </div>
        )
    }
}

const mapStateToProps = (state) => ({
    record: state.record
})
export default connect(mapStateToProps, {getTimerRecord  })(TimerGraph)