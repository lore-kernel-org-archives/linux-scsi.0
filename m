From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH V1 0/4] LU queue depth manament
Date: Thu,  5 Jun 2014 15:44:18 +0300
Message-ID: <1401972259-15471-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, sthumma@codeaurora.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Dolev Raviv <draviv@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

Resending patch 4, to fix the author.

Some UFS devices don't support a LUN queue depth same as the device queue
depth. This requires reading the unit descriptor for extracting the LU's
queue depth.

Dolev Raviv (1):
  scsi: ufs: query descriptor API
  scsi: ufs: device query status and size check
  scsi: ufs: Logical Unit (LU) command queue depth

Sujit Reddy Thumma (1):
  scsi: ufs: Fix queue depth handling for best effort cases

 drivers/scsi/ufs/ufs.h    |  38 +++++-
 drivers/scsi/ufs/ufshcd.c | 318 ++++++++++++++++++++++++++++++++--------------
 2 files changed, 261 insertions(+), 95 deletions(-)

-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
