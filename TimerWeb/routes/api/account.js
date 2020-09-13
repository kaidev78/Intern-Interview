const express = require('express');
const router = express.Router();
const account = require('../../models/Account')
const bcrypt = require('bcryptjs');
const config = require('config');
const jwt = require('jsonwebtoken');
const jwtdecode = require('jwt-decode');
const { response } = require('express');
const auth = require('../../middleware/auth');
// Register Account
router.post('/', (req, res) => {
    bcrypt.hash(req.body.password, 10, function(err, hash) {
        // Store hash in your password DB.
        const newItem = new account({
            username: req.body.username,
            password: hash
        })
        newItem.save().then(item => res.json(item))
        
    });
})

// login
router.post('/login', (req, res) => {
    const {username, password} = req.body;

    if(!username || !password){
        return res.status(400).json({msg: 'Please enter all fields'})
    }

    //Verify Account
    account.findOne({username})
     .then(user => {
         if(!user) return res.status(400).json({ msg: 'user does not exist'});

        //validate password
        bcrypt.compare(password, user.password)
        .then(isMatch => {
            if(!isMatch) return res.status(400).json({ msg: 'Invalid credentials'});
            jwt.sign(
            { 
              username: user.username,
              id: user._id
            },
            config.get('jwtSecret'),
            (err, token) => {
                if (err) throw err;
                res.json({
                    token,
                    username: user.username,
                    totalAccumulated: user.totalAccumulated,
                    id: user._id
                })
            }
        )        
        })
     })
});

// Get user
router.get('/:id', auth, (req, res)=>{
    try{
        account.findById(req.params.id).select('-password').then(user => res.json({user: user}))
    }catch(e){
        res.status(400).json({ msg: e.message });
    }
})

// Update account info
router.post('/:id/updateinfo', auth, (req, res) => {
    account.findByIdAndUpdate(req.params.id, {$set: {totalAccumulated: req.body.totalAccumulated }}, {returnOriginal: false}).select('-password')
    .then(updated => res.json({user: updated}))
})

//Register
router.post('/register', async (req, res) => {
    const { username, password, name, totalAccumulated } = req.body;
  
    // Simple validation
    if (!username || !name || !password) {
      return res.status(400).json({ msg: 'Please enter all fields' });
    }
  
    try {
      const user = await account.findOne({ username });
      if (user) throw Error('User already exists');
  
      const salt = await bcrypt.genSalt(10);
      if (!salt) throw Error('Something went wrong with bcrypt');
  
      const hash = await bcrypt.hash(password, salt);
      if (!hash) throw Error('Something went wrong hashing the password');
  
      const newUser = new account({
        name,
        username,
        password: hash,
        totalAccumulated
      });
  
      const savedUser = await newUser.save();
      if (!savedUser) throw Error('Something went wrong saving the user');
  
    //   const token = jwt.sign({ username: user.username,id: savedUser._id }, JWT_SECRET, {
    //     expiresIn: 3600
    //   });
  
      res.status(200).json({
        // token,
        user: {
          id: savedUser._id,
          name: savedUser.name,
          username: savedUser.username
        }
      });
    } catch (e) {
      res.status(400).json({ error: e.message });
    }
  });


  //GET USER TOTA ACCUMULATED
  router.post('/accumulatedtimes', auth, (req, res) => {
    account.find({}, {"name": 2,"totalAccumulated":1, "_id": 0}).sort({totalAccumulated: 1}).then(
      items => res.json(items)
    )
  })


  //Update account name
  router.post('/:id/updatename', auth, (req, res) => {
    account.findByIdAndUpdate(req.params.id, {$set: {name: req.body.name }}, {returnOriginal: false})
    .then(updated => res.json({user: updated}))
})

  //Update account password
  router.post('/:id/updatepassword', auth, async (req, res) => {

    const salt = await bcrypt.genSalt(10);
    if (!salt) throw Error('Something went wrong with bcrypt');

    const hash = await bcrypt.hash(req.body.password, salt);
    if (!hash) throw Error('Something went wrong hashing the password');

    account.findByIdAndUpdate(req.params.id, {$set: {password: hash}}, {returnOriginal: false})
    .then( res.json({msg: "password changed"}))
})

module.exports = router;