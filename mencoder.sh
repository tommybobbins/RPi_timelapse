#!/bin/bash
mencoder -nosound -ovc lavc -lavcopts vcodec=mpeg4:aspect=16/9:vbitrate=8000000 -vf scale=1360:768 -o bcblackpool.avi -mf type=jpeg:fps=24 mf://@stills.txt
