include CONFIG.cfg

CC = gcc
LD = gcc
CFLAGS = -g -O2 -Wall -Wextra -Wpedantic -Werror

EXEC = $(BUILD_DIR)/$(NAME)
SOURCE = $(SOURCE_DIR)/$(NAME).c
OBJECTS = $(NAME).o
LOG = $(patsubst $(TEST_DIR)/%.in, $(TEST_DIR)/%.log, $(wildcard $(TEST_DIR)/*.in))
PASS_TEST = true
FAIL_TEST = false

.PHONY: all check clean

all: $(EXEC)

$(EXEC): $(OBJECTS)
	$(LD) -o $(EXEC) $(OBJECTS)

$(BUILD_DIR): $(SOURCE)
	mkdir -p $(BUILD_DIR)

$(OBJECTS): $(SOURCE)  $(BUILD_DIR)
	$(CC) $(CFLAGS) -c -o $(OBJECTS) $(SOURCE)

check: $(LOG)

	@for log in $^ ; do \
        if [ "$$(cat $${log})" != "$(PASS_TEST)" ]; then \
            	exit 1; \
        fi; \
    done


$(TEST_DIR)/%.log: $(TEST_DIR)/%.in $(TEST_DIR)/%.out $(EXEC)

	@if [ "$$(./$(EXEC) ./$<)" = "$$(cat $(word 2, $^))" ]; then \
	echo "$< true"; \
        echo "$(PASS_TEST)" > $@; \
    else \
    	echo "$< false"; \
        echo "$(FAIL_TEST)" > $@; \
    fi



clean:
	$(RM) -r $(BUILD_DIR)/ $(LOG)