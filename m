From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 0/4] SCSI results rework preparation part 2
Date: Thu,  5 Jul 2018 13:01:36 +0200
Message-ID: <20180705110140.19545-1-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

As the first part of the preparation work for my scsi results handling
rework is done, here's the second batch.

The first patch changes the AAC_STAT_GOOD define into an open-coded
version in aacraid. The other three patches convert the three
ScsiResult() macros in bfa, lpfc and ncr53c8xx to their open-coded
equivalen.

This is helpful for subsequent refactoring, as it's easier to identify
which code parts need more work and Coccinelle Spatches are easier to
apply.

Johannes Thumshirn (4):
  scsi: aacraid: remove AAC_STAT_GOOD define
  scsi: bfa: remove ScsiResult macro
  scsi: lpfc: remove ScsiResult macro
  scsi: ncr53c8xx: remove ScsiResult macro

 drivers/scsi/aacraid/aachba.c | 41 ++++++++++++++++++++++++++--------------
 drivers/scsi/bfa/bfad_im.c    | 19 ++++++++-----------
 drivers/scsi/bfa/bfad_im.h    |  1 -
 drivers/scsi/lpfc/lpfc_crtn.h |  1 -
 drivers/scsi/lpfc/lpfc_scsi.c | 44 +++++++++++++++++++++----------------------
 drivers/scsi/ncr53c8xx.c      | 10 +++++-----
 6 files changed, 62 insertions(+), 54 deletions(-)

-- 
2.16.4
