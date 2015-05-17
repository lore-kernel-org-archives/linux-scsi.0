From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v1 00/10] *** introduce quirks for UFS host
Date: Sun, 17 May 2015 18:54:56 +0300
Message-ID: <1431878106-30579-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, dovl@codeaurora.org, draviv@codeaurora.org
List-Id: linux-scsi@vger.kernel.org

This series of patches introduce additional quirks and also,
their enabling in QUALCOMM Technologies specific code.

Yaniv Gardi (10):
  scsi: ufs: introduce the capability and quirk for interrupt
    aggregation
  scsi: ufs-qcom: don't enable interrupt aggregation
  scsi: ufs: provide a quirk to disable the LCC
  scsi: ufs-qcom: enable UFSHCD_QUIRK_BROKEN_LCC
  scsi: ufs: introduce a broken PA_RXHSUNTERMCAP quirk
  scsi: ufs-qcom: enable quirk to fix gear change to HS
  scsi: ufs: introduce UFSHCD_QUIRK_DME_PEER_ACCESS_AUTO_MODE quirk
  scsi: ufs-qcom: enable UFSHCD_QUIRK_DME_PEER_ACCESS_AUTO_MODE quirk
  scsi: ufs: add quirk to handle broken UFS HCI version
  scsi: ufs-qcom: enable UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION

 drivers/scsi/ufs/ufs-qcom.c |  39 ++++++++++++++--
 drivers/scsi/ufs/ufshcd.c   | 108 ++++++++++++++++++++++++++++++++++++++++++--
 drivers/scsi/ufs/ufshcd.h   |  53 +++++++++++++++++++++-
 drivers/scsi/ufs/ufshci.h   |   8 +++-
 4 files changed, 199 insertions(+), 9 deletions(-)

-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
