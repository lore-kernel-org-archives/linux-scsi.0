From: Juergen Gross <jgross@suse.com>
Subject: [PATCH] xen: make pvscsi frontend dependant on xenbus frontend
Date: Mon, 15 Sep 2014 06:45:01 +0200
Message-ID: <1410756301-23340-1-git-send-email-jgross@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jim.epost@gmail.com, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next <linux-next@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, konrad.wilk@oracle.com, boris.ostrovsky@oracle.com, david.vrabel@citrix.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>
List-Id: linux-scsi@vger.kernel.org

The pvscsi frontend driver requires the xenbus frontend driver. Reflect
this in Kconfig.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 drivers/scsi/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 9130df1..ff62dc1 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -579,6 +579,7 @@ config VMWARE_PVSCSI
 config XEN_SCSI_FRONTEND
 	tristate "XEN SCSI frontend driver"
 	depends on SCSI && XEN
+	select XEN_XENBUS_FRONTEND
 	help
 	  The XEN SCSI frontend driver allows the kernel to access SCSI Devices
 	  within another guest OS (usually Dom0).
-- 
1.8.4.5
