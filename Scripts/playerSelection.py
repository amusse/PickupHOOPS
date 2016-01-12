# Pickup Hoops Simulator
import math
import matplotlib.mlab as mlab
import matplotlib.pyplot as plt
import numpy
import random
import scipy.stats as stats
from scipy.spatial import distance
import time

# Constants
POP_SIZE = 1000
NUM_TRIALS = 50000
global total
total = 0.0


def createGame(player_ratings, player_loc_X, player_loc_Y, z):

	global total
	indices = []
	indices.append(random.randint(0, POP_SIZE - 1))
	rating_list = []
	founder = indices[0] # the index of the person who started a game
	rating_list.append(player_ratings[founder])
	loc = [player_loc_X[founder], player_loc_Y[founder]]
	avg_game_rating = numpy.mean(rating_list)

	# while the game is not yet full
	while (len(indices) < 10):

		possible_player = random.randint(0, POP_SIZE - 1)
		if (possible_player in indices):
			continue

		prob = 0.0

		# prob_r = 1 - (abs(player_ratings[possible_player] - avg_game_rating) / (player_ratings[possible_player] + avg_game_rating))

		# prob_fill = len(indices) / 9.0

		# prob += 0.25 * prob_r + 0.125 * prob_fill


		# initialize locations (constantly updating)
		for i in range(0, POP_SIZE):
			if i in indices:
				continue
			player_loc_X[i] = round(random.uniform(0, 50), 3)
			player_loc_Y[i] = round(random.uniform(0, 50), 3)

		new_loc = (player_loc_X[possible_player], 
				   player_loc_Y[possible_player]) 
		dist = distance.euclidean(loc, new_loc)
		maxD = (50.0 * math.pow(2, 0.5))

		# calculate prob_d rationally
		if (dist > maxD):
			continue
		else:
			prob_d = math.pow(1 - (dist / maxD), z)
			prob += 0.625 * prob_d

		sample = random.random()
		if (sample < prob):
			indices.append(possible_player)
			total += dist

	return indices;

player_ratings = [1000]*POP_SIZE
player_loc_X = [0]*POP_SIZE
player_loc_Y = [0]*POP_SIZE
games_played = [0]*POP_SIZE
team1 = []
team2 = []
game_players = []
averages = []
powers = []
times = []

for z in range(0, 50):
	n = 10
	total = 0
	start = time.time()
	for i in range(0, n):
		indices = createGame(player_ratings, player_loc_X, player_loc_Y, z)
	end = time.time()
	average = total / (n * 10.0)
	time_elap = (end - start)/n
	print("average for power = {} is {}".format(z, average))
	print("time for power = {} is {}".format(z, time_elap))

	averages.append(average)
	powers.append(z)
	times.append(time_elap)

plt.plot(powers, averages)
plt.title("Average travel distance vs. Exponent")
plt.xlabel("Exponent Values")
plt.ylabel("Average travel distance in miles")
plt.show()

plt.plot(powers, times)
plt.title("Average time (seconds) per game creation vs. Exponent")
plt.xlabel("Exponent Values")
plt.ylabel("Average time (seconds) to create game")
plt.show()

for i in range(0, len(averages)):
	print averages[i]
for i in range(0, len(powers)):
	print powers[i]
for i in range(0, len(averages)):
	print times[i]