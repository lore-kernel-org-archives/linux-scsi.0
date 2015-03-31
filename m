From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v1 0/2] *** scsi: ufs: add support for quirks ***
Date: Tue, 31 Mar 2015 17:37:12 +0300
Message-ID: <1427812635-16617-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, ygardi@codeaurora.org
List-Id: linux-scsi@vger.kernel.org

changes of v1:
- change#1: in this version we modify ufs_qcom_host structure to hold
  the UFS controller revision info.
- change#2: here we add quirks support for non standard behaviour of
  the controller.

Yaniv Gardi (2):
  scsi: ufs-qcom: save controller revision info in internal structure
  scsi: ufs: add support to allow non standard behaviours (quirks)

 drivers/scsi/ufs/ufs-qcom.c | 36 ++++++++++++++++++++++++------------
 drivers/scsi/ufs/ufs-qcom.h | 26 ++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.c   | 35 +++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.h   |  9 +++++++++
 4 files changed, 94 insertions(+), 12 deletions(-)

-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
