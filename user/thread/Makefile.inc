# -*-Makefile-*-

OBJDIRS += $(USER_OBJDIR)/thread

USER_thread_SRC += $(USER_DIR)/thread/futex_test.c $(USER_DIR)/thread/thread.c
USER_thread_OBJ := $(patsubst %.c, $(OBJDIR)/%.o, $(USER_thread_SRC))
USER_thread_OBJ := $(patsubst %.S, $(OBJDIR)/%.o, $(USER_thread_OBJ))

KERN_BINFILES += $(USER_OBJDIR)/thread/thread

thread: $(USER_OBJDIR)/thread/thread

$(USER_OBJDIR)/thread/thread: $(USER_LIB_OBJ) $(USER_thread_OBJ)
	@echo + ld[USER/thread] $@
	$(V)$(LD) -o $@ $(USER_LDFLAGS) $(USER_LIB_OBJ) $(USER_thread_OBJ) $(GCC_LIBS)
	$(V)$(OBJDUMP) -S $@ > $@.asm
	$(V)$(NM) -n $@ > $@.sym

$(USER_OBJDIR)/thread/%.o: $(USER_DIR)/thread/%.c
	@echo + cc[USER/thread] $<
	@mkdir -p $(@D)
	$(V)$(CC) $(USER_CFLAGS) -c -o $@ $<

$(USER_OBJDIR)/thread/%.o: $(USER_DIR)/thread/%.S
	@echo + as[USER/thread] $<
	@mkdir -p $(@D)
	$(V)$(CC) $(USER_CFLAGS) -c -o $@ $<
