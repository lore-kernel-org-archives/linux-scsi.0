From: ravi.anand@qlogic.com
Subject: [PATCH 03/11] Drop unused defines.
Date: Tue, 7 Mar 2006 16:35:27 -0800
Message-ID: <11417781222011-git-send-email-ravi.anand@qlogic.com>
References: <11417781172980-git-send-email-ravi.anand@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:56303 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S964845AbWCHAfb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2006 19:35:31 -0500
In-Reply-To: <11417781172980-git-send-email-ravi.anand@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, arjan@infradead.org
Cc: ravi.anand@qlogic.com

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>


---

 drivers/scsi/qla4xxx/ql4_def.h |    3 ---
 drivers/scsi/qla4xxx/ql4_fw.h  |   25 -------------------------
 2 files changed, 0 insertions(+), 28 deletions(-)

06f6483e4c0aed769faa93648ae667291c51ffd9
diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index c2e5f56..9eee21f 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -42,9 +42,6 @@
 #define IS_QLA4010(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP4010)
 #define IS_QLA4022(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP4022)
 
-#define QLA4010
-#define QLA4XXX_BOARD_PORTS		1
-#define QLA4XXX_PROC_NAME		"qla4010"
 #define QLA_SUCCESS			0
 #define QLA_ERROR			1
 
diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index 032e845..10f1852 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -4,38 +4,13 @@
  *
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
-
 #ifndef _QLA4X_FW_H
 #define _QLA4X_FW_H
 
-#ifndef uint64_t
-#define uint64_t __u64
-#endif
-
-#define QLA4XXX_VENDOR_ID   	0x1077
-#define QLA4000_DEVICE_ID  	0x4000
-#define QLA4010_DEVICE_ID  	0x4010
-
-#define QLA4040_SSDID_NIC  	0x011D	/* Uses QLA4010 PCI Device ID */
-#define QLA4040_SSDID_ISCSI  	0x011E
-#define QLA4040C_SSDID_NIC  	0x011F
-#define QLA4040C_SSDID_ISCSI  	0x0120
-
 #define MAX_PRST_DEV_DB_ENTRIES         64
 #define MIN_DISC_DEV_DB_ENTRY           MAX_PRST_DEV_DB_ENTRIES
 #define MAX_DEV_DB_ENTRIES              512
 
-// ISP Maximum number of DSD per command
-#define DSD_MAX                                 1024
-
-// FW check
-#define FW_UP(reg,stat)                         (((stat = RD_REG_DWORD(reg->mailbox[0])) != 0) && (stat != 0x0007))
-
-#define INVALID_REGISTER 			((uint32_t)-1)
-
-#define ISP4010_NET_FUNCTION                            0
-#define ISP4010_ISCSI_FUNCTION                          1
-
 /*************************************************************************
  *
  * 		ISP 4010 I/O Register Set Structure and Definitions
-- 
1.2.4.g9201-dirty


