mongoose = require "mongoose"
bcrypt = require "bcrypt"

# Set the salt work factor 10 is recommended
SALT_WORK_FACTOR = 10

# Setup the schema
UserSchema = mongoose.Schema
    email:
        type: String
        required: true
        unique: true
    password:
        type: String
        required: true
        unique: true

# Replace the plaintext password with bcrypt hash before it is saved
UserSchema.pre "save", (next) ->
    # If the password has not been modified skip this
    if not @isModified("password") then return next()

    # Generate the salt
    bcrypt.genSalt SALT_WORK_FACTOR, (error, salt) =>
        if error then return next(error)

        # Make the hash
        bcrypt.hash @password, salt, (error, hash) =>
            if error then return next(error)

            # Overwrite the password with the hashed version
            @password = hash
            next()

# A method to compare the passwords
UserSchema.methods.comparePassword = (testPassword, callback) ->
    bcrypt.compare testPassword, @password, (error, isMatch) ->
        if error then return next(error)
        
        callback null, isMatch

# Export the model
module.exports = mongoose.model "User", UserSchema
