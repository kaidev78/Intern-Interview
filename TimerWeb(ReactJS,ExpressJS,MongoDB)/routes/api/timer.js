const express = require('express');
const router = express.Router();
const auth = require('../../middleware/auth');
const Timer = require('../../models/Timer');
var dateFormat = require('dateformat')
const jwtdecode = require('jwt-decode');

// GET User timers
router.get('/', auth, (req, res) => {
    const token = req.header('x-auth-token');
    var username = jwtdecode(token)['username'];
    Timer.find({owner: username})
    .then(items => res.json(items))
});

// Get User Timer
router.get('/:id', auth, (req, res) => {
  Timer.findById(req.params.id).then
  (timer =>res.json(timer))
})

// Router Create Timers
router.post('/', auth, (req, res) => {
    const token = req.header('x-auth-token');
    var username = jwtdecode(token)['username'];
    const newItem = new Timer({
        timername: req.body.timername,
        accumulatedTime: 0,
        mostRecentupdate: null,
        owner: username
    })
    newItem.save().then(item => res.json(item))
})

// Delete a timer
router.delete('/:id', auth, async (req, res) => {
    try {
      const item = await Timer.findById(req.params.id);
      if (!item) throw Error('No item found');
  
      const removed = await item.remove();
      if (!removed)
        throw Error('Something went wrong while trying to delete the item');
  
      res.status(200).json({ success: true });
    } catch (e) {
      res.status(400).json({ msg: e.message, success: false });
    }
  });

  // Update a timer
  router.post('/update/:id', auth, (req, res) => {
    Timer.findOneAndUpdate({ _id: req.params.id},
      {$set: {timername: req.body.timername, mostRecentupdate: req.body.mostRecentupdate,
         accumulatedTime: req.body.accumulatedTime}}, {returnOriginal: false}).then( timer => res.json({timer: timer}))
  })

module.exports = router;