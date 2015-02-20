# Create account to keep track of anonymous posting.
# Use an unstored, randomly generated password so nobody can log in as "Anonymous"
# (I couldn't find a better solution that doesn't make bcrypt complain)
password = SecureRandom.hex(32)
User.create(:username => "Anonymous", :email => "NA@NA.INVALID",:password => password, :password_confirmation => password)
