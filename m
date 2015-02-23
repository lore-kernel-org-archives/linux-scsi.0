From: Gilad Broner <gbroner@codeaurora.org>
Subject: [PATCH v3 0/4] Add ioctl and debug utilities to UFS driver
Date: Mon, 23 Feb 2015 10:08:13 +0200
Message-ID: <1424678898-3723-1-git-send-email-gbroner@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51555 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbbBWIIa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Feb 2015 03:08:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, draviv@codeaurora.org, Gilad Broner <gbroner@codeaurora.org>

Changes from V2:
Fixed comment for debugfs change:
Added missing clean up to driver unload path and remove redundant macros.

Dolev Raviv (1):
  scsi: ufs: add ioctl interface for query request

Gilad Broner (1):
  scsi: ufs: add trace events and dump prints for debug

Lee Susman (1):
  scsi: ufs: add debugfs for ufs

Sujit Reddy Thumma (1):
  scsi: ufs: inject errors to verify error handling

 drivers/scsi/ufs/Makefile      |    1 +
 drivers/scsi/ufs/ufs-debugfs.c | 1042 ++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-debugfs.h |   42 ++
 drivers/scsi/ufs/ufs-qcom.c    |   53 ++
 drivers/scsi/ufs/ufs.h         |   53 +-
 drivers/scsi/ufs/ufshcd.c      |  959 ++++++++++++++++++++++++++++++++++--
 drivers/scsi/ufs/ufshcd.h      |  115 +++++
 drivers/scsi/ufs/ufshci.h      |    3 +
 include/trace/events/ufs.h     |  227 +++++++++
 include/uapi/scsi/Kbuild       |    1 +
 include/uapi/scsi/ufs/Kbuild   |    3 +
 include/uapi/scsi/ufs/ioctl.h  |   57 +++
 include/uapi/scsi/ufs/ufs.h    |   66 +++
 lib/Kconfig.debug              |   14 +
 14 files changed, 2552 insertions(+), 84 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufs-debugfs.c
 create mode 100644 drivers/scsi/ufs/ufs-debugfs.h
 create mode 100644 include/trace/events/ufs.h
 create mode 100644 include/uapi/scsi/ufs/Kbuild
 create mode 100644 include/uapi/scsi/ufs/ioctl.h
 create mode 100644 include/uapi/scsi/ufs/ufs.h

-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

