#!/usr/bin/env python

""" File: plot_multiple_g2.py
	Author: Sarah Lindner
	Date of last change: 10.02.2015

	Takes data from g2 functions and plots them one above the other.
"""

import matplotlib.pyplot as plt
import numpy as np
from sys import argv


# argv is your commandline arguments, argv[0] is your program name, so skip it
out_filename = argv[1]
in_files_data = argv[2::2]
in_files_fit = argv[3::2]

#slice filename to create title for plot
file_parts = out_filename.split('/')
title = file_parts[len(file_parts)-1]


xdata_plot=[]
ydata_plot=[]

ydata_fit=[]

#read in data
for in_file in in_files_data:
    print(in_file) #print out the filename we are currently processing

    xdata, ydata = np.loadtxt( in_file, delimiter="\t", usecols=(0, 1), unpack=True)

    xdata_plot.append(xdata)
    ydata_plot.append(ydata)


#read in fitdata
for in_file in in_files_fit:
    print(in_file) #print out the filename we are currently processing

    ydata = np.loadtxt( in_file, delimiter="\t", unpack=True)

    ydata_fit.append(ydata)




#As many subplots as input files
fig, axs = plt.subplots(len(in_files_data)) 

#plot data
for index, item in enumerate(axs):
	item.scatter(xdata_plot[index], ydata_plot[index], color='k', s=3)
	# item.plot(xdata_plot[index], ydata_plot[index], color='k')
	item.plot(xdata_plot[index], ydata_fit[index], 'r--')
	item.tick_params(axis = 'both', labelsize = 15)
	item.set_yticks([0.0, 0.25, 0.5, 0.75, 1, 1.25])


# Fine-tune figure:

# make subplots close to each other and hide x ticks for all but bottom plot.
fig.subplots_adjust(hspace=0)
plt.setp([a.get_xticklabels() for a in fig.axes[:-1]], visible=False)

# make title and labels
axs[0].set_title(title, fontsize = 23)
plt.xlabel('Time (ns)', fontsize = 20)
fig.text(0.02, 0.5, 'g$^{(2)}$', rotation='vertical', transform=fig.transFigure, horizontalalignment='left', fontsize = 23)



plt.savefig( (out_filename +'.png'))
plt.savefig( (out_filename +'.pdf'))

plt.show()