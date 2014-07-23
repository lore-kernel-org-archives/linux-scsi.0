From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH 0/2] scsi: ufs: fix sparse tool warning in ufs driver
Date: Wed, 23 Jul 2014 09:31:10 +0300
Message-ID: <1406097072-18148-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, sthumma@codeaurora.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Dolev Raviv <draviv@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

Few fixes noted by the sparse tool:
- make undeclared functions static
- fix endianness sparse warnings

Sujit Reddy Thumma (2):
  scsi: ufs: make undeclared functions static
  scsi: ufs: fix endianness sparse warnings

 drivers/scsi/ufs/ufshcd.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

-- 
1.8.5.2

--
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
