From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 0/2] Remove remainig MCR SCSI drivers
Date: Fri,  6 Jul 2018 15:33:47 +0200
Message-ID: <20180706133349.28508-1-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

MCR Support was ripped out of the kernel in 2012. I think 6 years
later we can kill the remaining drivers which couldn't have been
compiled since then.

Johannes Thumshirn (2):
  scsi: remove NCR_D700 driver
  scsi: remove NCR_Q720 driver

 MAINTAINERS             |   6 -
 drivers/scsi/Kconfig    |  32 +---
 drivers/scsi/Makefile   |   3 -
 drivers/scsi/NCR_D700.c | 405 ------------------------------------------------
 drivers/scsi/NCR_D700.h |  30 ----
 drivers/scsi/NCR_Q720.c | 376 --------------------------------------------
 drivers/scsi/NCR_Q720.h |  29 ----
 7 files changed, 4 insertions(+), 877 deletions(-)
 delete mode 100644 drivers/scsi/NCR_D700.c
 delete mode 100644 drivers/scsi/NCR_D700.h
 delete mode 100644 drivers/scsi/NCR_Q720.c
 delete mode 100644 drivers/scsi/NCR_Q720.h

-- 
2.16.4
