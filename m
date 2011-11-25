From: Petr Uzel <petr.uzel@suse.cz>
Subject: [PATCH 2/2] [SCSI] sd: Adapt comment and printk string after renaming sd_attach to sd_probe
Date: Fri, 25 Nov 2011 11:02:45 +0100
Message-ID: <1322215365-15655-2-git-send-email-petr.uzel@suse.cz>
References: <1322215365-15655-1-git-send-email-petr.uzel@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1322215365-15655-1-git-send-email-petr.uzel@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Make the comment and printk string match the code.

Signed-off-by: Petr Uzel <petr.uzel@suse.cz>
---
 drivers/scsi/sd.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c368e88..4b4233b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2554,8 +2554,8 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
  *	(e.g. /dev/sda). More precisely it is the block device major 
  *	and minor number that is chosen here.
  *
- *	Assume sd_attach is not re-entrant (for time being)
- *	Also think about sd_attach() and sd_remove() running coincidentally.
+ *	Assume sd_probe is not re-entrant (for time being)
+ *	Also think about sd_probe() and sd_remove() running coincidentally.
  **/
 static int sd_probe(struct device *dev)
 {
@@ -2570,7 +2570,7 @@ static int sd_probe(struct device *dev)
 		goto out;
 
 	SCSI_LOG_HLQUEUE(3, sdev_printk(KERN_INFO, sdp,
-					"sd_attach\n"));
+					"sd_probe\n"));
 
 	error = -ENOMEM;
 	sdkp = kzalloc(sizeof(*sdkp), GFP_KERNEL);
-- 
1.7.7
