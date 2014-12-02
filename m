From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH 0/2] Revert mpt2sas, mpt3sas: remove disconnected phys on topology change
Date: Tue,  2 Dec 2014 20:58:45 +0530
Message-ID: <1417534127-6189-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

Reverting the below commit IDs

1. [PATCH 1/2] mpt2sas: Remove phys on topology change
   commit ID: 3520f9c779bed098ca76dd3fb6377264301d57ed

2. [PATCH 2/2] mpt3sas: Remove phys on topology change
   commit ID: 963ba22b90a955363644cd397b20226928eab976

Sreekanth Reddy (2):
  Revert "[SCSI] mpt2sas: Remove phys on topology change."
  Revert "[SCSI] mpt3sas: Remove phys on topology change"

 drivers/scsi/mpt2sas/mpt2sas_transport.c | 5 +----
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 5 +----
 2 files changed, 2 insertions(+), 8 deletions(-)

-- 
2.0.2
