From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1 0/4] scsi: ufs: bug fixes, device quirk, HCI 2.1 support
Date: Mon,  5 Dec 2016 19:24:12 -0800
Message-ID: <1480994652-19573-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41830 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751378AbcLFDYW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2016 22:24:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>

This series has 2 bug fixes, 1 change related to device quirk and 1 change
to add UFS HCI 2.1 revision support.

Subhash Jadavani (2):
  scsi: ufs: add quirk to increase host PA_SaveConfigTime
  scsi: ufs-qcom: fix bug with read/modify write of UFS_CFG1

Yaniv Gardi (2):
  scsi: ufs: add support for UFS HCI 2.1
  scsi: ufs-qcom: add probe_defer in case phy driver not probed yet

 drivers/scsi/ufs/ufs-qcom.c   | 44 ++++++++++++++++++++++++++++++++--
 drivers/scsi/ufs/ufs-qcom.h   |  1 +
 drivers/scsi/ufs/ufs_quirks.h | 30 +++++++----------------
 drivers/scsi/ufs/ufshcd.c     | 55 +++++++++++++++++++++++++++++++++++++++----
 drivers/scsi/ufs/ufshcd.h     | 12 ++++++++--
 drivers/scsi/ufs/ufshci.h     |  7 ++++++
 6 files changed, 120 insertions(+), 29 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

