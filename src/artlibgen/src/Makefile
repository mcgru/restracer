CXX ?= c++
CXXFLAGS+=$(shell pkg-config --cflags libxml++-2.6) \
    -I../../libs/libtplreader -I../../libs/liblinefetch
LDFLAGS+=-L../../libs/libtplreader -L../../libs/liblinefetch \
    -ltplreader -llinefetch $(shell pkg-config --libs libxml++-2.6)
SOURCES=$(wildcard *.cc)
OBJECTS=$(SOURCES:.cc=.o)
TARGET=artlibgen

all: $(SOURCES) $(TARGET)

$(TARGET): $(OBJECTS)
	$(CXX) -o $@ $(OBJECTS) $(LDFLAGS)

.cc.o:
	$(CXX) -c $(CXXFLAGS) $< -o $@

.PHONY: clean
clean:
	rm -f $(TARGET) $(OBJECTS)
