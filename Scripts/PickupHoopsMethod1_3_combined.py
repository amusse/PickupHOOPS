# Pickup Hoops Simulator
import math
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
plt.ioff()
import numpy
import random
import scipy.stats as stats


# given a list of tuples (the player rating and their index in player_ratings)
# creates balanced teams 
def makeTeams(game_players):
	game_players = sorted(game_players)
	return [game_players[0],game_players[3],game_players[5],game_players[7], game_players[9]], [game_players[1],game_players[2],game_players[4],game_players[6],game_players[8]]

def calcTeamAvg(team):
	team_avg = 0
	for player in team:
		team_avg += player[0] / 5.0

	return team_avg

# calculates the expected win probability of a player with rating_A
# against a player with rating_B
def calcWinProb(rating_A, rating_B):
	return (1.0 / (1 + math.pow(10, (rating_B - rating_A) / 400.0)))

# won will be 0 if the team lost or 1 if the team won
def calcTeamRatingGain(won, win_prob):
	return (won - win_prob)

def calcPlayerRatingGain(teamRatingGain, games_played):
	if games_played < 10:
		K = 64
	else:
		K = 32

	return teamRatingGain * K


# Perform NUM_TRIALS number of games by doing the following:
	# Randomly select 10 players from the pool and put them into teams
	# Calculate each team's average rating and their win probabilities
	# Use that to simulate a win/loss and determine the ranking gain a team experiences
	# There are three systems for updating individual player's ratings:
		# 1): Each player gains the same amount as their team
		# 2): Each player gains a weighted average of their team's rating
			# i.e. a player will gain (1/5) * (their rating/team's avg rating) * team gain
			# this favors better players
		# 3): Each player gains an inverted weighted average of their team's rating
			# i.e. a player will gain (their rating/team's avg rating) / (1/5) * team gain
			# this favors worse players

for POP_SIZE in range(1000, 1500, 500):
	counter = 0
	lower_bound = int(POP_SIZE/10.0)
	upper_bound = int(POP_SIZE*2.0)
	increment = int(POP_SIZE/5.0)

	# print("\n")
	# print("****************************************************")
	# print("****************************************************")
	# print("         New Population size: {}".format(POP_SIZE))
	# print("****************************************************")
	# print("****************************************************")

	for NUM_TRIALS in range(500, 25500, 500):
		counter += 1
		# Method 1:
		player_ratings = [1000]*POP_SIZE
		games_played = [0]*POP_SIZE
		team1 = []
		team2 = []

		
		for i in range(0, 5000):
			game_players = []
			indices = random.sample(range(0, POP_SIZE), 10)

			for i in range(0,10):
				game_players.append((player_ratings[indices[i]], indices[i]))

			# team1 and team2 are tuples of the format (player rating, player index)
			team1, team2 = makeTeams(game_players)

			team1_avg = calcTeamAvg(team1)
			team2_avg = calcTeamAvg(team2)

			team1_win_prob = calcWinProb(team1_avg, team2_avg)
			outcome = random.random()

			# team 1 wins
			if outcome <= team1_win_prob:
				team1_gain = calcTeamRatingGain(1, team1_win_prob)
				team2_gain = calcTeamRatingGain(0, (1 - team1_win_prob))

			# team 2 wins
			else:
				team1_gain = calcTeamRatingGain(0, team1_win_prob)
				team2_gain = calcTeamRatingGain(1, (1 - team1_win_prob))


		# METHOD 3

			# calculate new player ratings
			for player in team1:
				games_played[player[1]] += 1
				player_rating_gain = calcPlayerRatingGain(team1_gain, games_played[player[1]])
				if player_ratings[player[1]] == 0:
					if player_rating_gain <= 250:
						player_gain = 0
					else:
						player_gain = 16
				else:
					player_gain = ((player_ratings[player[1]]/team1_avg) / (1.0/5.0) * player_rating_gain)
				player_ratings[player[1]] += player_gain

			for player in team2:
				games_played[player[1]] += 1
				player_rating_gain = calcPlayerRatingGain(team2_gain, games_played[player[1]])
				if player_ratings[player[1]] <= 250:
					if player_rating_gain <= 0:
						player_gain = 0
					else:
						player_gain = 16
				else:
					player_gain = ((player_ratings[player[1]]/team2_avg) / (1.0/5.0) * player_rating_gain)
				player_ratings[player[1]] += player_gain

		
########################################
########################################
########################################
########################################

		if NUM_TRIALS > 5000:
			for i in range(5000, NUM_TRIALS):
				game_players = []
				indices = random.sample(range(0, POP_SIZE), 10)

				for i in range(0,10):
					game_players.append((player_ratings[indices[i]], indices[i]))

				# team1 and team2 are tuples of the format (player rating, player index)
				team1, team2 = makeTeams(game_players)

				team1_avg = calcTeamAvg(team1)
				team2_avg = calcTeamAvg(team2)

				team1_win_prob = calcWinProb(team1_avg, team2_avg)
				outcome = random.random()

				# team 1 wins
				if outcome <= team1_win_prob:
					team1_gain = calcTeamRatingGain(1, team1_win_prob)
					team2_gain = calcTeamRatingGain(0, (1 - team1_win_prob))

				# team 2 wins
				else:
					team1_gain = calcTeamRatingGain(0, team1_win_prob)
					team2_gain = calcTeamRatingGain(1, (1 - team1_win_prob))


			# METHOD 1
				for player in team1:
					games_played[player[1]] += 1
					player_gain = (calcPlayerRatingGain(team1_gain, games_played[player[1]]))
					player_ratings[player[1]] += player_gain

				for player in team2:
					games_played[player[1]] += 1
					player_gain = (calcPlayerRatingGain(team2_gain, games_played[player[1]]))
					player_ratings[player[1]] += player_gain

		mean = numpy.mean(player_ratings)
		mean = int((mean * 1000) + 0.05) / 1000.0
		stddev = numpy.std(player_ratings)
		stddev = int((stddev * 1000) + 0.05) / 1000.0

		player_ratings = sorted(player_ratings)
		fit = stats.norm.pdf(player_ratings, numpy.mean(player_ratings), numpy.std(player_ratings))

		plt.plot(player_ratings,fit,'--r')
		n, bins, patches = plt.hist(player_ratings, normed=True, bins=40)
		plt.axis([-500, 5000, 0, 0.001])
		plt.xlabel("Player Rating")
		plt.ylabel("Frequency (normalized)")
		plt.title("Method 1/3: Pop size {}, Games played {}".format(POP_SIZE, NUM_TRIALS))
		plt.savefig("METHOD1_3_POP{}_GAME{}.png".format(POP_SIZE, NUM_TRIALS), bbox_inches='tight',dpi=100)
		plt.close()

