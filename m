From: Gilad Broner <gbroner@codeaurora.org>
Subject: [PATCH v1 0/4] Add ioctl and debug utilities to UFS driver
Date: Tue,  3 Feb 2015 17:37:16 +0200
Message-ID: <1422977841-25036-1-git-send-email-gbroner@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, draviv@codeaurora.org, Gilad Broner <gbroner@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

This patch series introduces in the first change a new UFS ioctl,
allowing user-space to send UFS queries and retrieve information from them.
In addition, the other three patches add utilities to support debugging
efforts and supply information that will help analysis of issue:
UFS trace events, dump host controller registers and requests descriptors
on failures, several statistics.

Dolev Raviv (1):
  scsi: ufs: add ioctl interface for query request

Gilad Broner (1):
  scsi: ufs: add trace events and dump prints for debug

Lee Susman (1):
  scsi: ufs: add debugfs for ufs

Sujit Reddy Thumma (1):
  scsi: ufs: inject errors to verify error handling

 drivers/scsi/ufs/Makefile     |    1 +
 drivers/scsi/ufs/debugfs.c    | 1038 +++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/debugfs.h    |   42 ++
 drivers/scsi/ufs/ufs-qcom.c   |   53 +++
 drivers/scsi/ufs/ufs.h        |   53 +--
 drivers/scsi/ufs/ufshcd.c     |  964 ++++++++++++++++++++++++++++++++++++--
 drivers/scsi/ufs/ufshcd.h     |  115 +++++
 drivers/scsi/ufs/ufshci.h     |    3 +
 include/linux/ftrace_event.h  |    3 +
 include/trace/events/ufs.h    |  227 +++++++++
 include/uapi/scsi/Kbuild      |    1 +
 include/uapi/scsi/ufs/Kbuild  |    3 +
 include/uapi/scsi/ufs/ioctl.h |   57 +++
 include/uapi/scsi/ufs/ufs.h   |   66 +++
 lib/Kconfig.debug             |   14 +
 15 files changed, 2556 insertions(+), 84 deletions(-)
 create mode 100644 drivers/scsi/ufs/debugfs.c
 create mode 100644 drivers/scsi/ufs/debugfs.h
 create mode 100644 include/trace/events/ufs.h
 create mode 100644 include/uapi/scsi/ufs/Kbuild
 create mode 100644 include/uapi/scsi/ufs/ioctl.h
 create mode 100644 include/uapi/scsi/ufs/ufs.h
-- 
1.8.5.2

-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
