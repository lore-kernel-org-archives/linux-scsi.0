From: Raviv Shvili <rshvili@codeaurora.org>
Subject: [RFC/PATCH 0/3] infrastructure and support for LU command queue depth
Date: Thu, 29 Aug 2013 17:58:35 +0300
Message-ID: <1377788315-5329-1-git-send-email-rshvili@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Raviv Shvili <rshvili@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

The following patch set implements read and write descriptor API.The device 
descriptor is aquired by the query command sent to the device.

Also, configuring the LU command queue depth, according to the LU unit
descriptor.

The following patches depends on
[PATCH -next] ufs: fix source address of the read descriptor
sent by Akinobu Mita <mita@fixstars.com>


Raviv Shvili (3):
  scsi: ufs: query descriptor API
  scsi: ufs: device query status and size check
  scsi: ufs: Logical Unit (LU) command queue depth

 drivers/scsi/ufs/ufs.h    |   38 +++++++-
 drivers/scsi/ufs/ufshcd.c |  232 ++++++++++++++++++++++++++++++++++++---------
 2 files changed, 225 insertions(+), 45 deletions(-)

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc.
is a member of Code Aurora Forum, hosted by The Linux Foundation
