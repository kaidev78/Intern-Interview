const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const AccountSchema = new Schema({
    username:{
        type: String
    },
    password: {
        type: String
    },
    name:{
        type: String
    },
    totalAccumulated:{
        type: Number
    }
});

module.exports = StudyTimer = mongoose.model('account', AccountSchema)