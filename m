From: Gilad Broner <gbroner@codeaurora.org>
Subject: [PATCH v9] scsi: ufs: add ioctl interface for query request
Date: Tue, 19 May 2015 13:02:45 +0300
Message-ID: <1432029766-16456-1-git-send-email-gbroner@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, draviv@codeaurora.org, Gilad Broner <gbroner@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

This patch was originally patch 1/3 in a patch series titled "Add ioctl and debug utilities to UFS driver".
As it has no dependency with the debug utilities it is separated from the series, and now stands on its own.

Dolev Raviv (1):
  scsi: ufs: add ioctl interface for query request

 drivers/scsi/ufs/ufs.h        |  53 +++--------
 drivers/scsi/ufs/ufshcd.c     | 205 +++++++++++++++++++++++++++++++++++++++++-
 include/scsi/scsi.h           |   1 +
 include/uapi/scsi/Kbuild      |   1 +
 include/uapi/scsi/ufs/Kbuild  |   3 +
 include/uapi/scsi/ufs/ioctl.h |  57 ++++++++++++
 include/uapi/scsi/ufs/ufs.h   |  66 ++++++++++++++
 7 files changed, 342 insertions(+), 44 deletions(-)
 create mode 100644 include/uapi/scsi/ufs/Kbuild
 create mode 100644 include/uapi/scsi/ufs/ioctl.h
 create mode 100644 include/uapi/scsi/ufs/ufs.h

-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
