From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH 0/3] ufs driver fixes and updates
Date: Tue,  1 Jul 2014 12:22:36 +0300
Message-ID: <1404206559-21445-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, sthumma@codeaurora.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Dolev Raviv <draviv@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

Misc fixes and updates for the UFS driver.

Dolev Raviv (1):
  scsi: ufs: read door bell register after clearing interrupt
    aggregation

Sujit Reddy Thumma (2):
  scsi: ufs: Fix sending unsupported SCSI command
  scsi: ufs: retry if the link-startup fails

 drivers/scsi/ufs/ufshcd.c | 95 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 61 insertions(+), 34 deletions(-)

-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
