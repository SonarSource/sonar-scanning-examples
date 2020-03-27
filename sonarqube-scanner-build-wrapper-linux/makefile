CC=g++
CFLAGS=-Wall

SRCDIR   = src
OBJDIR   = build

CPPSOURCES  := $(wildcard $(SRCDIR)/*.cpp)
CCSOURCES  := $(wildcard $(SRCDIR)/*.cc)
INCLUDES := $(wildcard $(SRCDIR)/*.h)
CCOBJECTS  := $(CPPSOURCES:$(SRCDIR)/%.cc=$(OBJDIR)/%.o)
CPPOBJECTS  := $(CCSOURCES:$(SRCDIR)/%.cpp=$(OBJDIR)/%.o)

all: clean $(CCOBJECTS) $(CPPOBJECTS)
	$(CC) $(CCOBJECTS) $(CPPOBJECTS) -o $(OBJDIR)/app
	chmod a+x $(OBJDIR)/app

$(CCOBJECTS): $(OBJDIR)/%.o : $(SRCDIR)/%.cc
	$(CC) $(CFLAGS) -c $< -o $@

$(CPPOBJECTS): $(OBJDIR)/%.o : $(SRCDIR)/%.cpp
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -rf $(OBJDIR)
	mkdir $(OBJDIR)

