From: Yaniv Gardi <ygardi@qti.qualcomm.com>
Subject: [PATCH v5 0/4] *** add support for UFS in QCOM platforms ***
Date: Wed,  7 Jan 2015 17:43:27 +0200
Message-ID: <1420645411-26222-1-git-send-email-ygardi@qti.qualcomm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:33787 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbbAGPnt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jan 2015 10:43:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, noag@codeaurora.org, draviv@codeaurora.org, Yaniv Gardi <ygardi@qti.qualcomm.com>

*** BLURB HERE ***

Yaniv Gardi (4):
  phy: qcom-ufs: add support for 20nm phy
  scsi:ufs-qcom: add specific support for Qualcomm platforms
  phy: qcom-ufs: add support for 14nm phy
  scsi: ufs-qcom-ice: add Inline Crypto Engine (ICE) support for UFS

 drivers/phy/Makefile                |    3 +
 drivers/phy/phy-qcom-ufs-i.h        |  167 ++++++
 drivers/phy/phy-qcom-ufs-qmp-14nm.c |  201 +++++++
 drivers/phy/phy-qcom-ufs-qmp-14nm.h |  177 ++++++
 drivers/phy/phy-qcom-ufs-qmp-20nm.c |  257 +++++++++
 drivers/phy/phy-qcom-ufs-qmp-20nm.h |  235 ++++++++
 drivers/phy/phy-qcom-ufs.c          |  745 ++++++++++++++++++++++++
 drivers/scsi/ufs/Kconfig            |   24 +
 drivers/scsi/ufs/Makefile           |    2 +
 drivers/scsi/ufs/ufs-qcom-ice.c     |  520 +++++++++++++++++
 drivers/scsi/ufs/ufs-qcom-ice.h     |  113 ++++
 drivers/scsi/ufs/ufs-qcom.c         | 1058 +++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-qcom.h         |  195 +++++++
 include/linux/phy/phy-qcom-ufs.h    |   33 ++
 14 files changed, 3730 insertions(+)
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
1.8.2.1

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
