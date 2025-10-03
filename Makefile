#General Purpose Makefile (Courtesy of Prateek Bhakta)

EXECS = assemble
OBJS = project1.o

# For *nix and Mac
CC = g++
CCFLAGS	 = -std=c++17 -I .

# On some older toolchains std::filesystem requires linking to stdc++fs. Try without first.
FS_LIB :=

all: $(EXECS)

assemble: $(OBJS)
	$(CC) $(CCFLAGS) $^ -o $@ $(FS_LIB)

%.o: %.cpp *.h
	$(CC) $(CCFLAGS) -c $<

clean:
	/bin/rm -f a.out $(OBJS) $(EXECS)
