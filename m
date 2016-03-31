From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v3 0/2] Update SCSI target removal path
Date: Thu, 31 Mar 2016 14:53:17 +0200
Message-ID: <cover.1459428540.git.jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Ewan D. Milne" <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is a follow up to "scsi: Add intermediate STARGET_REMOVE state to 
scsi_target_state".

If anyone has an idea how to create a regression test suite for the target
removal path I'd be all ears, given the fact that this is the 3rd or 4th patch
targeting it.

Changes to v2:
* Reverse the order of patches as pointed out by James

Changes to v1:
* Fix error (hit BUG_ON()) discovered by the 0-Day bot.
* Revert "scsi: fix soft lockup in scsi_remove_target() on module removal"

Johannes Thumshirn (2):
  scsi: Add intermediate STARGET_REMOVE state to scsi_target_state
  Revert "scsi: fix soft lockup in scsi_remove_target() on module
    removal"

 drivers/scsi/scsi_scan.c   | 2 ++
 drivers/scsi/scsi_sysfs.c  | 6 +++---
 include/scsi/scsi_device.h | 1 +
 3 files changed, 6 insertions(+), 3 deletions(-)

-- 
1.8.5.6
