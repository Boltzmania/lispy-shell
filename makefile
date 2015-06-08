COMP := csc

SOURCES := src/main.scm
TARGET := bin/lispy

$(TARGET):
	@echo "·Compiling..."
	@echo " $(COMP) -o $(TARGET) $(SOURCES)"; $(COMP) -o $(TARGET) $(SOURCES)

clean:
	@echo "·Cleaning..."
	@echo " rm $(TARGET)"; rm $(TARGET)

.PHONY: clean
