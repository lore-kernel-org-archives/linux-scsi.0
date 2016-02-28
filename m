From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v5 00/15] add fixes, device quirks, error recovery,
Date: Sun, 28 Feb 2016 15:32:32 +0200
Message-ID: <1456666367-11418-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, ygardi@codeaurora.org
List-Id: linux-scsi@vger.kernel.org

V5:
as per comment, patch 05/14 in V4, was divided into 2 patches in V5

V4:
fixed DOS EOL symbols in 2 new files

V3:
Due to comments in V2
Removed change 02/17 of V2 
Removed change 03/17 of V2
Removed change 17/17 of V2

V2:
This series should be pushed on top of 15 patches series:
"Big fixes, retries, handle a race condition"
fixed and few comments.

V1:
This series should be pushed on top of 15 patches series:
"Big fixes, retries, handle a race condition"


Yaniv Gardi (15):
  scsi: ufs-qcom: add number of lanes per direction
  scsi: ufs: avoid spurious UFS host controller interrupts
  scsi: ufs: implement scsi host timeout handler
  scsi: ufs: verify hba controller hce reg value
  scsi: ufs: add support to read device and string descriptors
  scsi: ufs: separate device and host quirks
  scsi: ufs: disable vccq if it's not needed by UFS device
  scsi: ufs: make error handling bit faster
  scsi: ufs: add error recovery after DL NAC error
  scsi: ufs: add retry for query descriptors
  scsi: ufs: handle non spec compliant bkops behaviour by device
  scsi: ufs: tune UniPro parameters to optimize hibern8 exit time
  scsi: ufs: fix leakage during link off state
  scsi: ufs: add device quirk delay before putting UFS rails in LPM
  scsi: ufs-qcom: set PA_Local_TX_LCC_Enable before link startup

 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |   3 +
 drivers/scsi/ufs/Makefile                          |   2 +-
 drivers/scsi/ufs/ufs-qcom.c                        | 155 ++++-
 drivers/scsi/ufs/ufs-qcom.h                        |   9 +
 drivers/scsi/ufs/ufs.h                             |  33 +
 drivers/scsi/ufs/ufs_quirks.c                      | 104 +++
 drivers/scsi/ufs/ufs_quirks.h                      | 133 ++++
 drivers/scsi/ufs/ufshcd-pltfrm.c                   |  19 +
 drivers/scsi/ufs/ufshcd.c                          | 749 ++++++++++++++++++---
 drivers/scsi/ufs/ufshcd.h                          |  40 +-
 drivers/scsi/ufs/ufshci.h                          |   4 +
 drivers/scsi/ufs/unipro.h                          |  22 +
 12 files changed, 1145 insertions(+), 128 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufs_quirks.c
 create mode 100644 drivers/scsi/ufs/ufs_quirks.h

-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
