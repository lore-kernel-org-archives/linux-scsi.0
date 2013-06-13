From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: [PATCH 0/4] scsi: ufs: Improve UFS error handling
Date: Thu, 13 Jun 2013 20:00:56 +0530
Message-ID: <1371133860-17574-1-git-send-email-sthumma@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>, linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, Sujit Reddy Thumma <sthumma@codeaurora.org>, linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The first patch fixes many issues with current task management handling
in UFSHCD driver. Others improve error handling in various scenarios.

These patches depends on:
[PATCH 2/8] scsi: ufs: wrap the i/o access operations
[PATCH 3/8] scsi: ufs: amend interrupt configuration
[PATCH 4/8] scsi: ufs: remove version check before IS reg clear
[PATCH 5/8] scsi: ufs: rework link start-up process
[PATCH 1/2] scsi: ufs: Add support for sending NOP OUT UPIU
[PATCH 2/2] scsi: ufs: Set fDeviceInit flag to initiate device initialization
[PATCH 1/2] scsi: ufs: Add support for host assisted background operations
[PATCH 2/2] scsi: ufs: Add runtime PM helpers for UFS host driver


Sujit Reddy Thumma (4):
  scsi: ufs: Fix broken task management command implementation
  scsi: ufs: Fix hardware race conditions while aborting a command
  scsi: ufs: Fix device and host reset methods
  scsi: ufs: Improve UFS fatal error handling

 drivers/scsi/ufs/ufshcd.c | 1009 ++++++++++++++++++++++++++++++++++++---------
 drivers/scsi/ufs/ufshcd.h |   10 +-
 drivers/scsi/ufs/ufshci.h |   19 +-
 3 files changed, 841 insertions(+), 197 deletions(-)

-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation.
