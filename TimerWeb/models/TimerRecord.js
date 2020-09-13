const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const TimerRecordSchema = new Schema({
    parentId:{
        type: String
    },
    todayTime: {
        type: Number
    },
    date: {
        type: String
    },
    parentName: {
        type: String
    }
});

module.exports = StudyTimer = mongoose.model('timer_record', TimerRecordSchema)