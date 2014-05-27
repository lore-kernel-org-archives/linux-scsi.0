From: "Dolev Raviv" <draviv@codeaurora.org>
Subject: RE: [PATCH V1 0/4] scsi: ufs: LU queue depth managment
Date: Tue, 27 May 2014 11:46:58 +0300
Message-ID: <002c01cf7988$3ab24af0$b016e0d0$@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Content-Language: en-us
Sender: linux-arm-msm-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, sthumma@codeaurora.org, linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Fixing a typo in the Subject.

Thanks,
Dolev
-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Dolev Raviv
Sent: Tuesday, May 27, 2014 10:22 AM
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org; linux-scsi-owner@vger.kernel.org;
sthumma@codeaurora.org; linux-arm-msm@vger.kernel.org; Dolev Raviv
Subject: [PATCH V1 0/4] LU queue depth manament

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
 drivers/scsi/ufs/ufshcd.c | 318
++++++++++++++++++++++++++++++++--------------
 2 files changed, 261 insertions(+), 95 deletions(-)

--
1.8.5.2

--
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the
body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html
