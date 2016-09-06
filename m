From: Long Li <longli@exchange.microsoft.com>
Subject: [PATCH 0/3] storvsc: fixes issues on Fiber Channel
Date: Tue,  6 Sep 2016 14:25:40 -0700
Message-ID: <1473197143-16760-1-git-send-email-longli@exchange.microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: devel@linuxdriverproject.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Long Li <longli@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

From: Long Li <longli@microsoft.com>

This patch set fixes connectivity issues and improves performance for Fiber Channel disks.

Long Li (3):
  Use tagged SRB requests if supported by the device
  Properly handle SRB_ERROR when sense message is present
  Use block layer default segment size

 drivers/scsi/storvsc_drv.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

-- 
1.8.5.6
