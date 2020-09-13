const express = require('express');
const router = express.Router();
const auth = require('../../middleware/auth');
const TimerRecord = require('../../models/TimerRecord');
var dateFormat = require('dateformat')
const jwtdecode = require('jwt-decode');

// GET User Timer Rcords
router.get('/:id', auth, (req, res) => {
    const token = req.header('x-auth-token');
    var username = jwtdecode(token)['username'];
    TimerRecord.find({parentId: req.params.id})
    .then(items => res.json(items))
});

// Router Create Timers Record
router.post('/', auth, (req, res) => {
    const token = req.header('x-auth-token');
    var username = jwtdecode(token)['username'];
    const newItem = new TimerRecord({
        parentId: req.body.parentId,
        todayTime: req.body.todayTime,
        date: req.body.date,
        parentName: username
    })
    newItem.save().then(item => res.json(item))
})

  // Update Timer Record
  router.post('/update', auth, (req, res) => {
    TimerRecord.findOneAndUpdate({parentId: req.body.parentId, date: req.body.date},
      {$set: {todayTime: req.body.todayTime}}).then(timer => res.json(timer))
  })

  // Delete Timer Record
  router.post('/delete', auth, (req, res) => {
      TimerRecord.deleteMany({parentId: req.body.parentId}).then(res.json({msg: "delete sucessfully"}))
  })

module.exports = router;