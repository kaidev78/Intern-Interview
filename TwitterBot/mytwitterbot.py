import sys
import simple_twit
import random
import datetime
import time

def getRandomUser(followers):
    randomPick = random.randint(0,len(followers)-1)
    return followers[randomPick]

def loadInspiration():
    quotes = []
    f = open("inspiration.txt","r")
    contents = f.readlines()
    for x in contents:
        quotes.append(x)
    return quotes

def pickRandomQuotes(quotes):
    randomPick = random.randint(0,len(quotes))
    return quotes[randomPick]

def tweetRandomFollower(api,randomFollower,quote):
    content = "@" + str(randomFollower.screen_name) + " " +quote
    simple_twit.send_tweet(api,content)


def main():
    # This call to simple_twit.create_api will create the api object that
    # Tweepy needs in order to make authenticated requests to Twitter's API.
    # Do not remove or change this function call.
    # Pass the variable "api" holding this Tweepy API object as the first
    # argument to simple_twit functions.
    api = simple_twit.create_api()
    # YOUR CODE BEGINS HERE
    quotes = loadInspiration()
    followers = simple_twit.get_my_followers(api,100)
    while(True):
        randomQuote = pickRandomQuotes(quotes)
        randomFollower = getRandomUser(followers)
        tweetRandomFollower(api,randomFollower,randomQuote)
        randomQuote = pickRandomQuotes(quotes)
        simple_twit.send_tweet(api,randomQuote)
        print("sended")
        time.sleep(3600)




if __name__ == "__main__":
       main()
