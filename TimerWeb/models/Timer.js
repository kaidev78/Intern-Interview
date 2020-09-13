const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const TimerSchema = new Schema({
    timername:{
        type: String
    },
    accumulatedTime: {
        type: Number
    },
    mostRecentupdate: {
        type: String
    },
    owner:{
        type: String
    }
});

module.exports = StudyTimer = mongoose.model('timer', TimerSchema)