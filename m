From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v7 0/5] phy: qcom-ufs: add support for QUALCOMM
Date: Thu, 15 Jan 2015 16:32:34 +0200
Message-ID: <1421332359-31785-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, noag@codeaurora.org, draviv@codeaurora.org
List-Id: linux-scsi@vger.kernel.org

Changes from V6:
- change#1 in the V6 series: 0001-phy-qcom-ufs-add-support-for-20nm-phy
  has been divided into 2 patches:
  A: phy: qcom-ufs: add support for QUALCOMM Technologies UFS PHY drivers
  B: phy: qcom-ufs: add support for 20nm phy
  in order to seperate the common code of the Qualcomm Technologies
  UFS PHYs and the specific UFS PHYs that will be added.

Yaniv Gardi (5):
  phy: qcom-ufs: add support for QUALCOMM Technologies UFS PHY drivers
  phy: qcom-ufs: add support for 20nm phy
  scsi: ufs-qcom: add support for Qualcomm Technologies Inc platforms
  phy: qcom-ufs: add support for 14nm phy
  scsi: ufs-qcom-ice: add Inline Crypto Engine (ICE) support for UFS

 drivers/phy/Kconfig                 |    7 +
 drivers/phy/Makefile                |    3 +
 drivers/phy/phy-qcom-ufs-i.h        |  159 ++++++
 drivers/phy/phy-qcom-ufs-qmp-14nm.c |  201 +++++++
 drivers/phy/phy-qcom-ufs-qmp-14nm.h |  177 ++++++
 drivers/phy/phy-qcom-ufs-qmp-20nm.c |  257 +++++++++
 drivers/phy/phy-qcom-ufs-qmp-20nm.h |  235 ++++++++
 drivers/phy/phy-qcom-ufs.c          |  745 ++++++++++++++++++++++++
 drivers/scsi/ufs/Kconfig            |   25 +
 drivers/scsi/ufs/Makefile           |    2 +
 drivers/scsi/ufs/ufs-qcom-ice.c     |  520 +++++++++++++++++
 drivers/scsi/ufs/ufs-qcom-ice.h     |  113 ++++
 drivers/scsi/ufs/ufs-qcom.c         | 1058 +++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-qcom.h         |  195 +++++++
 include/linux/phy/phy-qcom-ufs.h    |   59 ++
 15 files changed, 3756 insertions(+)
 create mode 100644 drivers/phy/phy-qcom-ufs-i.h
 create mode 100644 drivers/phy/phy-qcom-ufs-qmp-14nm.c
 create mode 100644 drivers/phy/phy-qcom-ufs-qmp-14nm.h
 create mode 100644 drivers/phy/phy-qcom-ufs-qmp-20nm.c
 create mode 100644 drivers/phy/phy-qcom-ufs-qmp-20nm.h
 create mode 100644 drivers/phy/phy-qcom-ufs.c
 create mode 100644 drivers/scsi/ufs/ufs-qcom-ice.c
 create mode 100644 drivers/scsi/ufs/ufs-qcom-ice.h
 create mode 100644 drivers/scsi/ufs/ufs-qcom.c
 create mode 100644 drivers/scsi/ufs/ufs-qcom.h
 create mode 100644 include/linux/phy/phy-qcom-ufs.h

-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
