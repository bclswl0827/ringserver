
DIRS = pcre mxml libmseed src

# Check if automake command exists
AUTOMAKE := $(shell command -v automake 2> /dev/null)

ifeq ($(AUTOMAKE),)
$(error "Automake is not installed. Please install Automake to proceed.")
endif

# Test for Makefile/makefile and run make, run configure if it exists
# and no Makefile does.

# As a special case for pcre do not pass targets except "clean".

all clean install ::
	@for d in $(DIRS) ; do \
	  if [ ! -f $$d/Makefile -a ! -f $$d/makefile ] ; then \
	    if [ -x $$d/configure -a "$$d" = "pcre" ] ; then \
	      echo "Running configure in $$d" ; \
              ( cd $$d && touch -c * ) ; \
	      ( cd $$d && ./configure --with-link-size=4 --disable-shared --enable-static --disable-cpp --build=loongarch64-linux-gnu ) ; \
	    elif [ -x $$d/configure -a "$$d" = "mxml" ] ; then \
	       echo "Running configure in $$d" ; \
	      ( cd $$d && ./configure --disable-shared --enable-threads --build=loongarch64-linux-gnu ) ; \
	    else \
	      echo "Running configure in $$d" ; \
	      ( cd $$d && ./configure --build=loongarch64-linux-gnu ) ; \
	    fi ; \
	  fi ; \
	  echo "Running $(MAKE) $@ in $$d" ; \
	  if [ -f $$d/Makefile -o -f $$d/makefile ] ; then \
	    if [ "$$d" = "pcre" -a "$@" != "clean" ] ; then \
	      ( cd $$d && $(MAKE) ) ; \
	    else \
	      ( cd $$d && $(MAKE) $@ ) ; \
	    fi ; \
	  elif [ -d $$d ] ; \
	    then ( echo "ERROR: no Makefile/makefile in $$d for $(CC)" ) ; \
	  fi ; \
	done
	
