From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH 0/6] various fixes for UFS-PM series
Date: Thu, 23 Oct 2014 13:25:11 +0300
Message-ID: <1414059917-13831-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Dolev Raviv <draviv@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

Contains a couple of bug fixes reported by Akinobu Mita, In adition to
"static checker" warnings reported by Dan Carpenter.

Akinobu Mita (1):
  scsi: ufs: fix reference counting of W-LUs

Dolev Raviv (4):
  scsi: ufs: fix static checker errors in ufshcd_system_suspend
  scsi: ufs: fix static checker warning in ufshcd_populate_vreg
  scsi: ufs: fix static checker warning in __ufshcd_setup_clocks
  scsi: ufs: fix static checker warning in ufshcd_parse_clock_info

Yaniv Gardi (1):
  scsi: ufs: fix power info after link start-up

 drivers/scsi/ufs/ufshcd-pltfrm.c | 15 +++----
 drivers/scsi/ufs/ufshcd.c        | 96 +++++++++++++++++++++++-----------------
 drivers/scsi/ufs/ufshcd.h        |  2 -
 3 files changed, 61 insertions(+), 52 deletions(-)

-- 
1.8.5.2
-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project
