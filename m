From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v2 0/8] Fix error message and present UFS variant
Date: Thu, 20 Aug 2015 16:58:56 +0300
Message-ID: <1440079144-26461-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: robherring2@gmail.com, James.Bottomley@HansenPartnership.com, pebolle@tiscali.nl, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org
List-Id: linux-scsi@vger.kernel.org

V2 fixes a few issues of unnecessary EXPORT_SYMBOL,
types of parameters in routine definition, 
build errors in case CONFIG_PM is not defined and some
other minor fixes.

Yaniv Gardi (8):
  phy: qcom-ufs: fix build error when the component is built as a module
  scsi: ufs-qcom: fix compilation warning if compiled as a module
  scsi: ufs-qcom: update configuration option of SCSI_UFS_QCOM component
  add ufshcd_get_variant ufshcd_set_variant
  scsi: ufs: creates wrapper functions for vops
  scsi: ufs: make the UFS variant a platform device
  scsi: ufs-qcom: add debug prints for test bus
  scsi: ufs-qcom: add QUniPro hardware support and power optimizations

 drivers/phy/phy-qcom-ufs.c       |  11 +
 drivers/scsi/ufs/Kconfig         |   2 +-
 drivers/scsi/ufs/ufs-qcom.c      | 917 +++++++++++++++++++++++++++++++--------
 drivers/scsi/ufs/ufs-qcom.h      |  68 ++-
 drivers/scsi/ufs/ufshcd-pltfrm.c |  92 +---
 drivers/scsi/ufs/ufshcd-pltfrm.h |  41 ++
 drivers/scsi/ufs/ufshcd.c        | 122 +++---
 drivers/scsi/ufs/ufshcd.h        | 149 ++++++-
 8 files changed, 1070 insertions(+), 332 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufshcd-pltfrm.h

-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
