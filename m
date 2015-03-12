From: Gilad Broner <gbroner@codeaurora.org>
Subject: [PATCH v7 0/3] Add ioctl and debug utilities to UFS driver
Date: Thu, 12 Mar 2015 17:54:57 +0200
Message-ID: <1426175700-23152-1-git-send-email-gbroner@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, draviv@codeaurora.org, Gilad Broner <gbroner@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

Changes from V6:
Moved NULL user argument check from ufshcd_ioctl to ufshcd_query_ioctl.
Add comment in include/scsi/scsi.h to note 0x5388 is in use.

Dolev Raviv (1):
  scsi: ufs: add ioctl interface for query request

Gilad Broner (1):
  scsi: ufs: add trace events and dump prints for debug

Lee Susman (1):
  scsi: ufs: add debugfs for ufs

 drivers/scsi/ufs/Makefile      |   1 +
 drivers/scsi/ufs/ufs-debugfs.c | 902 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-debugfs.h |  38 ++
 drivers/scsi/ufs/ufs-qcom.c    |  53 +++
 drivers/scsi/ufs/ufs.h         |  53 +--
 drivers/scsi/ufs/ufshcd.c      | 964 +++++++++++++++++++++++++++++++++++++++--
 drivers/scsi/ufs/ufshcd.h      | 110 +++++
 drivers/scsi/ufs/ufshci.h      |   3 +
 include/scsi/scsi.h            |   1 +
 include/trace/events/ufs.h     | 213 +++++++++
 include/uapi/scsi/Kbuild       |   1 +
 include/uapi/scsi/ufs/Kbuild   |   3 +
 include/uapi/scsi/ufs/ioctl.h  |  57 +++
 include/uapi/scsi/ufs/ufs.h    |  66 +++
 14 files changed, 2375 insertions(+), 90 deletions(-)
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
