const express = require('express');
const mongoose = require('mongoose');
const app = express();
const config = require('config');
const path = require('path');

//parser middleware
app.use(express.json());

// DB CONFIG
const db = config.get('mongoURI');

//Connect to Mongo
mongoose.connect(db, {useFindAndModify: false})
.then(()=> console.log('MongoDB Connected'))
.catch(err => console.log(err));

//User Routes
app.use('/api/user', require('./routes/api/account'))
app.use('/api/timer', require('./routes/api/timer'))
app.use('/api/timerrecord', require('./routes/api/timerrecord'))


//Serve static assets if in production
if(process.env.NODE_ENV === 'production'){
    //set staic folder
    app.use(express.static('client/build'));

    app.get('*', (req, res) => {
        res.sendFile(path.resolve(__dirname, 'client', 'build', 'index.html'));
    })
}

const port = process.env.PORT || 3001;

app.listen(port, () => console.log(`server started on ${port}`));
