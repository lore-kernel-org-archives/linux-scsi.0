From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH V1 0/4] LU queue depth manament
Date: Tue, 27 May 2014 10:21:48 +0300
Message-ID: <1401175312-17753-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:38821 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbaE0HWb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 May 2014 03:22:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, sthumma@codeaurora.org, linux-arm-msm@vger.kernel.org, Dolev Raviv <draviv@codeaurora.org>

Some UFS devices don't support a LUN queue depth same as the device queue
depth. This requires reading the unit descriptor for extracting the LU's
queue depth.

Dolev Raviv (1):
  scsi: ufs: query descriptor API

Raviv Shvili (2):
  scsi: ufs: device query status and size check
  scsi: ufs: Logical Unit (LU) command queue depth

Sujit Reddy Thumma (1):
  scsi: ufs: Fix queue depth handling for best effort cases

 drivers/scsi/ufs/ufs.h    |  38 +++++-
 drivers/scsi/ufs/ufshcd.c | 318 ++++++++++++++++++++++++++++++++--------------
 2 files changed, 261 insertions(+), 95 deletions(-)

-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation

