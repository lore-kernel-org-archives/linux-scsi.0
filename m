From: John Pittman <jpittman@redhat.com>
Subject: [PATCH] sd: Cleaned up comment references to @sdp argument explanation.
Date: Thu, 12 Jan 2017 16:24:24 -0500
Message-ID: <1484256264-30405-1-git-send-email-jpittman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Pittman <jpittman@redhat.com>
List-Id: linux-scsi@vger.kernel.org

In sd.c there are two comment references to 'struct scsi_device *sdp'
as an argument.  One of the references has a typo and the other should
be a reference to 'struct device *dev' instead.

Fixed by correcting the typo in the first and changing the explanation
in the second.

Signed-off-by: John Pittman <jpittman@redhat.com>

Edited to
---
 drivers/scsi/sd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b193304..52105d8 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -703,7 +703,7 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 
 /**
  * sd_setup_discard_cmnd - unmap blocks on thinly provisioned device
- * @sdp: scsi device to operate one
+ * @sdp: scsi device to operate on
  * @rq: Request to prepare
  *
  * Will issue either UNMAP or WRITE SAME(16) depending on preference
@@ -3192,7 +3192,7 @@ static int sd_probe(struct device *dev)
  *	sd_remove - called whenever a scsi disk (previously recognized by
  *	sd_probe) is detached from the system. It is called (potentially
  *	multiple times) during sd module unload.
- *	@sdp: pointer to mid level scsi device object
+ *	@dev: pointer to device object
  *
  *	Note: this function is invoked from the scsi mid-level.
  *	This function potentially frees up a device name (e.g. /dev/sdc)
-- 
2.5.5
