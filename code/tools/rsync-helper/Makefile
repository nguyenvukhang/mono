SRC := /media/khang/Riemann/assets/@/
DST := /media/khang/Robin/assets/@/

SRC := /media/khang/Riemann/assets/khang/
DST := /media/khang/Robin/assets/khang/

# SRC := /home/khang/repos/nextcloud/data/html/data/khang/files/
# DST := /media/khang/Riemann/assets/khang/nextcloud/

SRC := /home/khang/repos/immich/library/upload/
DST := /media/khang/Robin/assets/khang/immich/upload/

RSYNC := rsync
# RSYNC += --checksum   # use a checksum to check if the file needs to be copied.
RSYNC += --progress
RSYNC += --recursive
RSYNC += --perms   # preserve permissions.
RSYNC += --times   # preserve modification times.
# RSYNC += --owner   # preserve owner.
# RSYNC += --group   # preserve group.
RSYNC += --specials   # preserve special files.
# RSYNC += --hard-links   # preserve hard links.
RSYNC += --no-inc-recursive   # scan the full file list before starting.

# RSYNC += --dry-run

current: sync

t01:
	$(RSYNC) ./test/dir0/ ./test/dir1/

t10:
	$(RSYNC) ./test/dir1/ ./test/dir0/

sync:
	$(RSYNC) $(SRC) $(DST)

diff:
	diff --recursive --brief $(SRC) $(DST)
	# $(RSYNC) --dry-run $(SRC) $(DST)

send:
	$(RSYNC) /media/khang/Riemann/assets/khang/ /media/khang/Robin/assets/khang/
