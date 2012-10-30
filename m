From: Jeff Moyer <jmoyer@redhat.com>
Subject: [patch 04/10] sd: use alloc_disk_node
Date: Tue, 30 Oct 2012 16:14:38 -0400
Message-ID: <1351628084-29358-7-git-send-email-jmoyer@redhat.com>
References: <1351628084-29358-1-git-send-email-jmoyer@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1351628084-29358-1-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 drivers/scsi/sd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 12f6fdf..8deb915 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2714,7 +2714,7 @@ static int sd_probe(struct device *dev)
 	if (!sdkp)
 		goto out;
 
-	gd = alloc_disk(SD_MINORS);
+	gd = alloc_disk_node(SD_MINORS, dev_to_node(dev));
 	if (!gd)
 		goto out_free;
 
-- 
1.7.1
