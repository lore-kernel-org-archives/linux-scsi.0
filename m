From: madhu.iyengar@qlogic.com
Subject: [PATCH 02/11] qla2xxx: Correct buffer start in edc sysfs debug print.
Date: Tue, 10 May 2011 11:30:07 -0700
Message-ID: <1305052216-17347-3-git-send-email-madhu.iyengar@qlogic.com>
References: <1305052216-17347-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:39915 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1751542Ab1EJSgd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 May 2011 14:36:33 -0400
In-Reply-To: <1305052216-17347-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Joe Carnuccio <joe.carnuccio@qlogic.com>

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

The debug print prints the first byte of the buffer which is buf[8].

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 260c030..4e51124 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -633,7 +633,7 @@ qla2x00_sysfs_write_edc(struct file *filp, struct kobject *kobj,
 	if (rval != QLA_SUCCESS) {
 		DEBUG2(qla_printk(KERN_INFO, ha,
 		    "Unable to write EDC (%x) %02x:%02x:%04x:%02x:%02x.\n",
-		    rval, dev, adr, opt, len, *buf));
+		    rval, dev, adr, opt, len, buf[8]));
 		return 0;
 	}
 
-- 
1.6.0.2

