From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v3 0/2] Preparation patch-set for SCSI results rework
Date: Mon, 25 Jun 2018 13:20:57 +0200
Message-ID: <20180625112059.12872-1-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

This is small patch set with obvious prep patches for the SCSI results
rework discussed at LFS/MM and other occasions on the list.

Changes since v2:
- Dropped already applied patch 1
- Incorporated Bart's and Christoph's feedback
- Added Reviewed-bys

Johannes Thumshirn (2):
  scsi: check for equality of result byte values
  scsi: don't add scsi command result bytes

 drivers/scsi/ch.c                   |  2 +-
 drivers/scsi/dc395x.c               |  5 ++---
 drivers/scsi/imm.c                  |  2 +-
 drivers/scsi/mesh.c                 |  4 ++--
 drivers/scsi/scsi.c                 |  2 +-
 drivers/scsi/scsi_ioctl.c           |  4 ++--
 drivers/scsi/scsi_lib.c             |  4 ++--
 drivers/scsi/scsi_scan.c            |  2 +-
 drivers/scsi/scsi_transport_spi.c   |  2 +-
 drivers/scsi/sd.c                   | 14 +++++++-------
 drivers/scsi/sym53c8xx_2/sym_glue.c |  2 +-
 drivers/scsi/sym53c8xx_2/sym_glue.h |  2 +-
 drivers/scsi/ufs/ufshcd.c           |  2 +-
 13 files changed, 23 insertions(+), 24 deletions(-)

-- 
2.16.4
