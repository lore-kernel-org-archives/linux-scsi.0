From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 0/3] scsi: fcoe: memleak fixes
Date: Tue, 31 Jul 2018 15:46:00 +0200
Message-ID: <20180731134603.20089-1-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, ard <ard@kwaak.net>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

Ard reported a memory leak in FCoE at [1] and this patch set contains
the fix for this leak, a second leak I discovered while hunting the
first leak and a use-after-free in FCoE's debugging.

[1] https://marc.info/?l=linux-scsi&m=153261165228133&w=2

Johannes Thumshirn (3):
  fcoe: fix use-after-free in fcoe_ctlr_els_send
  scsi: fcoe: drop frames in ELS LOGO error path
  scsi: fcoe: clear FC_RP_STARTED flags when receiving a LOGO

 drivers/scsi/fcoe/fcoe_ctlr.c | 6 +++---
 drivers/scsi/libfc/fc_rport.c | 1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

-- 
2.16.4
