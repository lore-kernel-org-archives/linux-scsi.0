From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH V1 0/8] ufs patch siries
Date: Mon, 13 May 2013 13:02:10 +0300
Message-ID: <1368439340-26346-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Dolev Raviv <draviv@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

This patch series clusters the latest version of all the UFS patches in the
SCSI mailing list. It gives a stable functional base line for the UFS driver.

It includes the following versions:
> [PATCH 1/2] Documentation: devicetree: Add DT bindings for UFS host
> controller
> [PATCH 2/2] scsi: ufs: Fix the response UPIU length setting
> [PATCH v4 1/6] scsi: ufs: wrap the i/o access operations
> [PATCH v4 2/6] scsi: ufs: amend interrupt configuration
> [PATCH v4 3/6] scsi: ufs: fix interrupt status clears
> [PATCH v4 4/6] scsi: ufs: rework link start-up process
> [PATCH V5 1/1] scsi: ufs: Add support for sending NOP OUT UPIU
> [PATCH V4] scsi: ufs: Set fDeviceInit flag to initiate device
> initialization

But does not include:
> [PATCH v4 5/6] scsi: ufs: add dme configuration primit
> [PATCH v4 6/6] scsi: ufs: add dme control primitives


Dolev Raviv (8):
  Documentation: devicetree: Add DT bindings for UFS host controller
  scsi: ufs: Fix the response UPIU length setting
  scsi: ufs: wrap the i/o access operations
  scsi: ufs: amend interrupt configuration
  scsi: ufs: fix interrupt status clears
  scsi: ufs: rework link start-up process
  scsi: ufs: Add support for sending NOP OUT UPIU
  scsi: ufs: Set fDeviceInit flag to initiate device initialization

 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |   16 +
 drivers/scsi/ufs/ufs.h                             |   10 +-
 drivers/scsi/ufs/ufshcd.c                          |  839 ++++++++++++++++----
 drivers/scsi/ufs/ufshcd.h                          |   25 +-
 drivers/scsi/ufs/ufshci.h                          |    5 +-
 5 files changed, 721 insertions(+), 174 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt

-- 
1.7.6

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
