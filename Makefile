
#****************************************#
#                                        #
#    Makefile to build Xplore package    #
#                                        #
#****************************************#

PKGNAME   :=  Xplore
ELFNAME   :=  xplore
TARGET    :=  $(ELFNAME).cgi

SRCDIR    :=  src
OBJDIR    :=  obj
SHARE     :=  share
DIRBUILD  :=  __build

PREFIX    :=  /usr/local
CGIPREFIX ?=  /usr/lib
HTPREFIX  ?=  /var/www/html
DIRCGIBIN :=  $(CGIPREFIX)/cgi-bin
DIRCFG    :=  $(PREFIX)/etc/$(ELFNAME)

CC        ?=  gcc
CFLAGS    += -g -O3 -MMD -fPIE
LDFLAGS   += -static
LDLIBS    += -lkstat -lmagic -llzma -lbz2 -lz

WFLAGS    += -Wall -Wextra -Wstrict-prototypes -Wno-unused-parameter # -Wpedantic
WFLAGS    += -Walloca -Warray-bounds -Wcast-align -Wcast-qual -Wconversion -Wformat=2 -Wformat-security \
             -Wimplicit-fallthrough -Wint-conversion -Wnull-dereference -Wshadow -Wshift-overflow \
             -Wstack-protector -Wstrict-overflow=4 -Wswitch-default -Wswitch-enum -Wundef -Wvla

FSTACK    := -fstack-protector-all -fstack-protector-strong

ifneq (,$(wildcard $(HOME)/.termux))
    CPPFLAGS += -DTERMUX
    WFLAGS   +=
else
    CPPFLAGS += -Wdate-time -D_FORTIFY_SOURCE=2
    WFLAGS   += -Wduplicated-branches -Wduplicated-cond -Wformat-overflow=2 -Wformat-signedness -Wformat-truncation=2 \
                -Wlogical-op -Wstringop-overflow=4 -Wtraditional-conversion -Wtrampolines -Wstack-usage=4096
    FSTACK   += -fstack-clash-protection
    FASAN    += -fsanitize=bounds-strict
endif

CFLAGS  += $(FSTACK) $(FASAN)
LDFLAGS += $(FASAN)

BOLD := $(shell tput bold)
NC   := $(shell tput sgr0)

# Xplore sources
SRCS := $(SRCDIR)/main.c $(SRCDIR)/cgi.c $(SRCDIR)/html.c $(SRCDIR)/tree.c

# Object files
OBJS := $(SRCS:%.c=$(OBJDIR)/%.o)

# Build dependencies
DEPS := $(OBJS:%.o=%.d)

# Makefile execution starts here
all: info $(TARGET)

info:
	@echo "\n$(BOLD)Building $(PKGNAME) ...$(NC)"
	@echo "COMPILER : $(CC)"
	@echo "CFLAGS   : $(CFLAGS)"
	@echo "CPPFLAGS : $(CPPFLAGS)"
	@echo "LDFLAGS  : $(LDFLAGS)"
	@echo "LDLIBS   : $(LDLIBS)\n"

# Link object files and generate executable
$(TARGET): $(OBJS)
	@echo  "\n$(BOLD)Linking object files ...$(NC)"
	$(CC) -o $(TARGET) $(OBJS) $(LDFLAGS) $(LDLIBS)
	@echo "$(BOLD)$(PKGNAME)$(NC) build completed [$(BOLD)$(TARGET)$(NC)]"

# Build object file for each .c file
$(OBJDIR)/%.o : %.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) $(WFLAGS) $(CPPFLAGS) -c $< -o $@

run:
	rm -rf $(DIRBUILD)
	mkdir -p $(DIRBUILD)
	cp -rvf $(SHARE)/* $(DIRBUILD)
	install -D $(TARGET) $(DIRBUILD)/cgi-bin/$(TARGET)
	cd $(DIRBUILD) && python -m http.server --cgi 1111

install:
	mkdir -p $(DESTDIR)$(DIRCFG)
	mkdir -p $(DESTDIR)$(HTPREFIX)/$(ELFNAME)
	cp -f  $(SHARE)/xplore.cfg  $(DESTDIR)$(DIRCFG)
	cp -f  $(SHARE)/xplore.path $(DESTDIR)$(DIRCFG)
	cp -rf $(SHARE)/js          $(DESTDIR)$(HTPREFIX)/$(ELFNAME)
	cp -rf $(SHARE)/html        $(DESTDIR)$(HTPREFIX)/$(ELFNAME)
	cp -f  $(SHARE)/style.css   $(DESTDIR)$(HTPREFIX)/$(ELFNAME)
	cp -f  $(SHARE)/index.html  $(DESTDIR)$(HTPREFIX)/$(ELFNAME)
	install -D $(TARGET)        $(DESTDIR)$(DIRCGIBIN)/$(TARGET)

uninstall:
	rm -rf $(DESTDIR)$(DIRCFG)
	rm -f  $(DESTDIR)$(DIRCGIBIN)/$(TARGET)
	rm -rf $(DESTDIR)$(HTPREFIX)/$(ELFNAME)

KTAGSDIR  := __ktags
COREFILES := core vgcore*
clean:
	rm -rf $(TARGET) $(OBJDIR) $(COREFILES) $(DIRBUILD) $(KTAGSDIR)

-include $(DEPS)

.PHONY: all clean info install uninstall

# EOF
