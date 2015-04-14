From: Gilad Broner <gbroner@codeaurora.org>
Subject: [PATCH v8 0/3] Add ioctl and debug utilities to UFS driver
Date: Tue, 14 Apr 2015 14:51:18 +0300
Message-ID: <1429012281-24068-1-git-send-email-gbroner@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, draviv@codeaurora.org, Gilad Broner <gbroner@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

Changes from V7:
Fix handling of copy_from_user() result in case of incomplete copy in ufshcd_query_ioctl().
Fix ufs-debugfs build in case UFS is configured as a loadable kernel module.

Dolev Raviv (1):
  scsi: ufs: add ioctl interface for query request

Gilad Broner (1):
  scsi: ufs: add trace events and dump prints for debug

Lee Susman (1):
  scsi: ufs: add debugfs for ufs

 drivers/scsi/ufs/Makefile      |   3 +-
 drivers/scsi/ufs/ufs-debugfs.c | 901 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-debugfs.h |  38 ++
 drivers/scsi/ufs/ufs-qcom.c    |  53 +++
 drivers/scsi/ufs/ufs.h         |  53 +--
 drivers/scsi/ufs/ufshcd.c      | 957 ++++++++++++++++++++++++++++++++++++++---
 drivers/scsi/ufs/ufshcd.h      | 110 +++++
 drivers/scsi/ufs/ufshci.h      |   3 +
 include/scsi/scsi.h            |   1 +
 include/trace/events/ufs.h     | 213 +++++++++
 include/uapi/scsi/Kbuild       |   1 +
 include/uapi/scsi/ufs/Kbuild   |   3 +
 include/uapi/scsi/ufs/ioctl.h  |  57 +++
 include/uapi/scsi/ufs/ufs.h    |  66 +++
 14 files changed, 2368 insertions(+), 91 deletions(-)
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
