import twitter
import csv
from time import sleep

# Set up a config.py file with your values
# can create/get your existing from https://apps.twitter.com/
from config import key, secret, token_key, token_secret

api = twitter.Api(consumer_key = key,
                      consumer_secret = secret,
                      access_token_key = token_key,
                      access_token_secret = token_secret)


def all_tweets(name):
    """ Twitter limits the number of tweets returned to 200
    per call and 3200 total. So this itterate through them to
    get all tweets. """
    raw_statuses = []
    last_id = ''
    for i in range(0,16):
        page = api.GetUserTimeline(screen_name = name,
                                count = 200, max_id = last_id)
        raw_statuses.extend(page)
        last_id = page[(len(page)-1)].id
    return raw_statuses


def write_csv(tweet_list, file_name):
    """ Write all tweets passed to it to csv"""
    with open(file_name, 'wb') as csvfile:
        quotewriter = csv.writer(csvfile)
        quotewriter.writerow(['id',
                    'canidate',
                    'created',
                    'text',
                    'likes',
                    'retweets'])
        for tweet in tweet_list:
            quotewriter.writerow([tweet.id,
                                tweet.user.name.encode("utf-8"),
                                tweet.created_at,
                                tweet.text.encode("utf-8"),
                                tweet.favorite_count,
                                tweet.retweet_count])


def everyones_tweets(tweeters):
    """ Gets all tweets from everyone in list passed to it
    Twitter rate limits agresively so this waits 15 minutes after
    each."""
    for tweeter in tweeters:
        tweets_name = "tweets/" + tweeter + ".csv"
        write_csv(all_tweets(tweeter), tweets_name)
        sleep(900)


# Everyone iinterested in feeding in
tweeters = [
    'HillaryClinton',
    'BernieSanders',
    'realDonaldTrump',
    'tedcruz',
    'JohnKasich',
    'rdpeng',
    'jtleek',
    'bcaffo',
    'hspter',
    'hadleywickham',
    'kanyewest',
    'kendricklamar',
    'djkhaled']


everyones_tweets(tweeters)








