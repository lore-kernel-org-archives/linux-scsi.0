From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v2 0/3] Preparation patch-set for SCSI results rework
Date: Wed, 13 Jun 2018 09:53:46 +0200
Message-ID: <20180613075349.7509-1-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

This is small patch set with obvious prep patches for the SCSI results
rework discussed at LFS/MM and other occasions on the list.

Note, I'll be on PTO for the next two weeks so I'll be slow in
responding to this patches.


Johannes Thumshirn (3):
  scsi: remove Scsi_Cmnd typedef
  scsi: check for equality of result byte values
  scsi: don't add scsi command result bytes

 drivers/scsi/3w-xxxx.c              |  2 +-
 drivers/scsi/advansys.c             |  2 +-
 drivers/scsi/aha152x.c              | 71 ++++++++++++++++++++-----------------
 drivers/scsi/aha1740.c              |  9 ++---
 drivers/scsi/aha1740.h              |  4 +--
 drivers/scsi/ch.c                   |  2 +-
 drivers/scsi/dc395x.c               |  3 +-
 drivers/scsi/gdth.c                 | 67 +++++++++++++++++-----------------
 drivers/scsi/gdth.h                 | 10 +++---
 drivers/scsi/gdth_proc.c            |  2 +-
 drivers/scsi/ibmvscsi/ibmvfc.c      |  2 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c    |  2 +-
 drivers/scsi/imm.c                  |  2 +-
 drivers/scsi/libiscsi_tcp.c         |  2 +-
 drivers/scsi/megaraid.c             | 29 +++++++--------
 drivers/scsi/megaraid.h             | 14 ++++----
 drivers/scsi/mesh.c                 |  4 +--
 drivers/scsi/nsp32_debug.c          |  2 +-
 drivers/scsi/scsi.c                 |  2 +-
 drivers/scsi/scsi.h                 |  3 --
 drivers/scsi/scsi_ioctl.c           |  4 +--
 drivers/scsi/scsi_lib.c             |  4 +--
 drivers/scsi/scsi_scan.c            |  2 +-
 drivers/scsi/scsi_transport_spi.c   |  2 +-
 drivers/scsi/scsi_typedefs.h        |  2 --
 drivers/scsi/sd.c                   | 14 ++++----
 drivers/scsi/sym53c8xx_2/sym_glue.c |  2 +-
 drivers/scsi/sym53c8xx_2/sym_glue.h |  2 +-
 drivers/scsi/ufs/ufshcd.c           |  2 +-
 29 files changed, 136 insertions(+), 132 deletions(-)
 delete mode 100644 drivers/scsi/scsi_typedefs.h

-- 
2.16.4
