From: Jeff Moyer <jmoyer@redhat.com>
Subject: [patch,v3,repost 05/10] sd: use alloc_disk_node
Date: Tue, 27 Nov 2012 11:46:33 -0500
Message-ID: <1354034799-8460-6-git-send-email-jmoyer@redhat.com>
References: <1354034799-8460-1-git-send-email-jmoyer@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1354034799-8460-1-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, JBottomley@parallels.com
Cc: Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 drivers/scsi/sd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 12f6fdf..a5dae6b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2714,7 +2714,7 @@ static int sd_probe(struct device *dev)
 	if (!sdkp)
 		goto out;
 
-	gd = alloc_disk(SD_MINORS);
+	gd = alloc_disk_node(SD_MINORS, scsi_host_get_numa_node(sdp->host));
 	if (!gd)
 		goto out_free;
 
-- 
1.7.1
