From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [BK PATCH] SCSI -rc1 fixes
Date: 14 Nov 2004 15:20:59 -0600
Message-ID: <1100467267.23710.7.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261336AbUKNVV0@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is my first set of -rc fixes for SCSI.  The patch is available at

bk://linux-scsi.bkbits.net/scsi-for-linus-2.6

The short changelog is:

Adam J. Richter:
  o dmx3191d.c lacked MODULE_DEVICE_TABLE()

Alan Stern:
  o SCSI core: Fix refcounting error

Andrew Vasquez:
  o SCSI: fix `risc_code_addr01' multiple definition

James Bottomley:
  o make osst compile again after st structure changes

Jan Dittmer:
  o aic7xxx remove warnings

Jens Axboe:
  o fix SCSI bounce limit

Kai M=E4kisara:
  o SCSI tape: remove remaining typedefs

Matthew Wilcox:
  o sym2 2.1.18m

Maximilian Attems:
  o scsi/scsi_lib: replace  schedule_timeout() with
  o scsi/53c700: replace    schedule_timeout() with

Randy Dunlap:
  o qla1280: driver_setup not __initdata

Sergey S. Kostyliov:
  o Add megaraid PCI IDs


And the diffstat

 Documentation/scsi/sym53c8xx_2.txt    |  360 +++++++++++--------------=
-----
 drivers/scsi/53c700.c                 |    2=20
 drivers/scsi/aic7xxx/aic7xxx_osm.c    |    4=20
 drivers/scsi/dmx3191d.c               |    1=20
 drivers/scsi/megaraid/megaraid_mbox.c |    6=20
 drivers/scsi/osst.c                   |   55 ++--
 drivers/scsi/osst.h                   |    4=20
 drivers/scsi/qla1280.c                |    2=20
 drivers/scsi/qlogicfc_asm.c           |   10=20
 drivers/scsi/scsi_lib.c               |   18 -
 drivers/scsi/scsi_scan.c              |    3=20
 drivers/scsi/scsi_sysfs.c             |    2=20
 drivers/scsi/st.c                     |  221 +++++++++---------
 drivers/scsi/st.h                     |   20 -
 drivers/scsi/sym53c8xx_2/sym53c8xx.h  |   47 ----
 drivers/scsi/sym53c8xx_2/sym_defs.h   |  100 ++++----
 drivers/scsi/sym53c8xx_2/sym_glue.c   |  396 +++++++++++++------------=
---------
 drivers/scsi/sym53c8xx_2/sym_glue.h   |    3=20
 drivers/scsi/sym53c8xx_2/sym_hipd.c   |  100 +++-----
 drivers/scsi/sym53c8xx_2/sym_misc.c   |    4=20
 20 files changed, 569 insertions(+), 789 deletions(-)

James
