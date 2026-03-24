.PHONY: clean

SOURCES=$(wildcard *.cc)
OBJECTS=$(SOURCES:.cc=.o)
TARGET=main

all: $(SOURCES) $(TARGET) Makefile

$(TARGET): $(OBJECTS)
	$(CXX) -o $@ $(OBJECTS)

.cc.o:
	$(CXX) -c $(CFLAGS) $< -o $@

clean:
	rm -f $(TARGET) $(OBJECTS)
