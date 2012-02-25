# This Makefile is used under Linux

MATLABDIR ?= /Applications/MATLAB_R2011b.app
CXX ?= g++
#CXX = g++-3.3
CC ?= gcc
CFLAGS = -Wall -Wconversion -O3 -fPIC -I$(MATLABDIR)/extern/include -I.. -D _DENSE_REP
SCFLAGS = -Wall -Wconversion -O3 -fPIC -I$(MATLABDIR)/extern/include -I.. 

MEX = $(MATLABDIR)/bin/mex
MEX_OPTION = CC\#$(CXX) CXX\#$(CXX) CFLAGS\#"$(CFLAGS)" CXXFLAGS\#"$(CFLAGS)"
SMEX_OPTION = CC\#$(CXX) CXX\#$(CXX) CFLAGS\#"$(SCFLAGS)" CXXFLAGS\#"$(SCFLAGS)"

# comment the following line if you use MATLAB on a 32-bit computer
 MEX_OPTION += -largeArrayDims
SMEX_OPTION += -largeArrayDims
MEX_EXT = $(shell $(MATLABDIR)/bin/mexext)

OCTAVEDIR ?= /usr/include/octave
OCTAVE_MEX = env CC=$(CXX) mkoctfile
OCTAVE_MEX_OPTION = --mex
OCTAVE_MEX_EXT = mex
OCTAVE_CFLAGS = -Wall -O3 -fPIC -I$(OCTAVEDIR) -I..

all:	matlab

matlab:	binary

octave:
	@make MEX="$(OCTAVE_MEX)" MEX_OPTION="$(OCTAVE_MEX_OPTION)" \
	MEX_EXT="$(OCTAVE_MEX_EXT)" CFLAGS="$(OCTAVE_CFLAGS)" \
	binary

binary: train.$(MEX_EXT) predict.$(MEX_EXT) libsvmread.$(MEX_EXT) libsvmwrite.$(MEX_EXT) strain.$(MEX_EXT) spredict.$(MEX_EXT)

train.$(MEX_EXT): train.c ../linear.h tron.o linear.o linear_model_matlab.o ../blas/blas.a
	$(MEX) $(MEX_OPTION) train.c tron.o linear.o linear_model_matlab.o ../blas/blas.a

predict.$(MEX_EXT): predict.c ../linear.h tron.o linear.o linear_model_matlab.o ../blas/blas.a
	$(MEX) $(MEX_OPTION) predict.c tron.o linear.o linear_model_matlab.o ../blas/blas.a

strain.$(MEX_EXT): train.c ../linear.h stron.o slinear.o slinear_model_matlab.o ../blas/blas.a
	$(MEX) $(SMEX_OPTION) -output strain train.c stron.o slinear.o slinear_model_matlab.o ../blas/blas.a

spredict.$(MEX_EXT): predict.c ../linear.h stron.o slinear.o slinear_model_matlab.o ../blas/blas.a
	$(MEX) $(SMEX_OPTION) -output spredict predict.c stron.o slinear.o slinear_model_matlab.o ../blas/blas.a

libsvmread.$(MEX_EXT):	libsvmread.c
	$(MEX) $(MEX_OPTION) libsvmread.c

libsvmwrite.$(MEX_EXT):	libsvmwrite.c
	$(MEX) $(MEX_OPTION) libsvmwrite.c

linear_model_matlab.o: linear_model_matlab.c ../linear.h
	$(CXX) $(CFLAGS) -c linear_model_matlab.c

linear.o: ../linear.cpp ../linear.h
	$(CXX) $(CFLAGS) -c ../linear.cpp

tron.o: ../tron.cpp ../tron.h
	$(CXX) $(CFLAGS) -c ../tron.cpp
slinear_model_matlab.o: linear_model_matlab.c ../linear.h
	$(CXX) $(SCFLAGS) -o slinear_model_matlab.o -c linear_model_matlab.c

slinear.o: ../linear.cpp ../linear.h
	$(CXX) $(SCFLAGS) -o slinear.o -c ../linear.cpp

stron.o: ../tron.cpp ../tron.h
	$(CXX) $(SCFLAGS) -o stron.o -c ../tron.cpp

../blas/blas.a:
	cd ../blas; make OPTFLAGS='$(SCFLAGS)' CC='$(CC)';


clean:
	cd ../blas;	make clean
	rm -f *~ *.o *.mex* *.obj
