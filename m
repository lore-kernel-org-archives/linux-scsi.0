From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH V2 0/5] scsi: ufs: LU queue depth management
Date: Tue, 22 Jul 2014 17:23:45 +0300
Message-ID: <1406039030-14246-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, sthumma@codeaurora.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Dolev Raviv <draviv@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

New version to fix multiple 'sparse' warnings.
Add a driver wide fix to the endian 'sparse' warnings.
Some UFS devices don't support a LUN queue depth same as the device queue
depth. This requires reading the unit descriptor for extracting the LU's
queue depth.

Changes from V1:
 - Add static modifier to ufshcd_query_descriptor function due to 'sparse'
   warrning in [PATCH V1 1/4]
 - Add new patch [PATCH V2 2/5] to deal with 'sparse' endian warnings
 - Fix buf_len endian on [PATCH V1 2/4]

Dolev Raviv (1):
  scsi: ufs: device query status and size check
  scsi: ufs: query descriptor API
  scsi: ufs: Logical Unit (LU) command queue depth

Sujit Reddy Thumma (2):
  scsi: ufs: fix endianness sparse warnings
  scsi: ufs: Fix queue depth handling for best effort cases

 drivers/scsi/ufs/ufs.h    |  38 +++++-
 drivers/scsi/ufs/ufshcd.c | 319 ++++++++++++++++++++++++++++++++--------------
 2 files changed, 262 insertions(+), 95 deletions(-)

-- 
1.8.5.2
