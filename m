From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: [PATCH 0/2] scsi: ufs: Add support to control UFS device background operations
Date: Thu, 13 Jun 2013 19:50:03 +0530
Message-ID: <1371133205-17377-1-git-send-email-sthumma@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>, linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, Sujit Reddy Thumma <sthumma@codeaurora.org>, linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Add host assisted background operations for UFS device and runtime PM
helpers for ufshcd platform and pci glue drivers. The background operations
are disabled during runtime resume and enabled when the device is idle and
runtime suspended.

These patches depends on:
[PATCH 2/8] scsi: ufs: wrap the i/o access operations
[PATCH 3/8] scsi: ufs: amend interrupt configuration
[PATCH 4/8] scsi: ufs: remove version check before IS reg clear
[PATCH 5/8] scsi: ufs: rework link start-up process
[PATCH 1/2] scsi: ufs: Add support for sending NOP OUT UPIU
[PATCH 2/2] scsi: ufs: Set fDeviceInit flag to initiate device initialization

Sujit Reddy Thumma (2):
  scsi: ufs: Add support for host assisted background operations
  scsi: ufs: Add runtime PM helpers for UFS host driver

 drivers/scsi/ufs/ufs.h           |   25 +++-
 drivers/scsi/ufs/ufshcd-pci.c    |   60 ++++++-
 drivers/scsi/ufs/ufshcd-pltfrm.c |   41 +++++
 drivers/scsi/ufs/ufshcd.c        |  343 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.h        |   10 +
 5 files changed, 472 insertions(+), 7 deletions(-)

-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation.
