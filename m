From: Jeff Moyer <jmoyer@redhat.com>
Subject: [patch,v3 05/10] sd: use alloc_disk_node
Date: Fri,  9 Nov 2012 14:18:02 -0500
Message-ID: <1352488687-19935-6-git-send-email-jmoyer@redhat.com>
References: <1352488687-19935-1-git-send-email-jmoyer@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755367Ab2KITS3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Nov 2012 14:18:29 -0500
In-Reply-To: <1352488687-19935-1-git-send-email-jmoyer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, "James E.J. Bottomley" <JBottomley@parallels.com>


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

