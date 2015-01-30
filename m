From: Andy Grover <agrover@redhat.com>
Subject: [PATCHv2 2/5] scsi: Move ioctl defs from scsi/scsi.h to scsi/scsi_ioctl.h
Date: Thu, 29 Jan 2015 16:56:34 -0800
Message-ID: <1422579397-18696-3-git-send-email-agrover@redhat.com>
References: <1422579397-18696-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424AbbA3A4n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jan 2015 19:56:43 -0500
In-Reply-To: <1422579397-18696-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, hch@lst.de

These can be consolidated into scsi_ioctl.h with the other ones.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 include/scsi/scsi.h       | 21 ---------------------
 include/scsi/scsi_ioctl.h | 20 ++++++++++++++++++++
 2 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index cf778fe..012f493 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -565,27 +565,6 @@ static inline int scsi_is_wlun(u64 lun)
 #define SCSI_INQ_PQ_NOT_CON     0x01
 #define SCSI_INQ_PQ_NOT_CAP     0x03
 
-
-/*
- * Here are some scsi specific ioctl commands which are sometimes useful.
- *
- * Note that include/linux/cdrom.h also defines IOCTL 0x5300 - 0x5395
- */
-
-/* Used to obtain PUN and LUN info.  Conflicts with CDROMAUDIOBUFSIZ */
-#define SCSI_IOCTL_GET_IDLUN		0x5382
-
-/* 0x5383 and 0x5384 were used for SCSI_IOCTL_TAGGED_{ENABLE,DISABLE} */
-
-/* Used to obtain the host number of a device. */
-#define SCSI_IOCTL_PROBE_HOST		0x5385
-
-/* Used to obtain the bus number for a device */
-#define SCSI_IOCTL_GET_BUS_NUMBER	0x5386
-
-/* Used to obtain the PCI location of a device */
-#define SCSI_IOCTL_GET_PCI		0x5387
-
 /* Pull a u32 out of a SCSI message (using BE SCSI conventions) */
 static inline __u32 scsi_to_u32(__u8 *ptr)
 {
diff --git a/include/scsi/scsi_ioctl.h b/include/scsi/scsi_ioctl.h
index 8d19d1d..4d9f71f 100644
--- a/include/scsi/scsi_ioctl.h
+++ b/include/scsi/scsi_ioctl.h
@@ -15,6 +15,26 @@
 #define	SCSI_REMOVAL_PREVENT	1
 #define	SCSI_REMOVAL_ALLOW	0
 
+/*
+ * Here are some scsi specific ioctl commands which are sometimes useful.
+ *
+ * Note that include/linux/cdrom.h also defines IOCTL 0x5300 - 0x5395
+ */
+
+/* Used to obtain PUN and LUN info.  Conflicts with CDROMAUDIOBUFSIZ */
+#define SCSI_IOCTL_GET_IDLUN		0x5382
+
+/* 0x5383 and 0x5384 were used for SCSI_IOCTL_TAGGED_{ENABLE,DISABLE} */
+
+/* Used to obtain the host number of a device. */
+#define SCSI_IOCTL_PROBE_HOST		0x5385
+
+/* Used to obtain the bus number for a device */
+#define SCSI_IOCTL_GET_BUS_NUMBER	0x5386
+
+/* Used to obtain the PCI location of a device */
+#define SCSI_IOCTL_GET_PCI		0x5387
+
 #ifdef __KERNEL__
 
 struct scsi_device;
-- 
2.1.0

