Norm's Tidy Codebook
========================================================

Introduction
--------------------------------------------------------
My analysis of the text file that describes the features in the data set was the main source of generating the variables for the tidy data set.  I saw the following variables:

1.  Subject.  This is the same as the original data set with one exception.  Since one requirement was to generate the average of each activity with all subjects, for those enteries the value for subject was "All".
2.  Activity.  Same as original, wiht the updated descriptions.
3.  Acceleration Type.  There were two types of samples of acceleration: Body and Gravity to account for acceleration due to the person's body and gravity.
4.  Device.  Two devices were used:  Accelerometer and Gyroscope.
5.  Domain.  Both time domain and frequency domain samples were in the data set.  In general these are processed separately due to the different domains.
6.  Statistics.  In some cases the data sample is a mean, others a standard deviation.
Signal.  In some cases the signal is a value, others a magnitude.
7.  Axis.  There are separte axis samples {X,Y,Z} and 3D (all axis) samples.
8.  Motion.  There are three types of samples.  Angular velocity, acceleration, jerk (derivitive of acceleration)
9.  The last column is the numeric data sample.  Note this is an average of the original set per the project instructions.

Final File
---------------------------------------------------------
The final file contains 15996 observations of 10 variables. The file is sorted by subject and activity.  


