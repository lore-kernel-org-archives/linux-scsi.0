From: "H Hartley Sweeten" <hartleys@visionengravers.com>
Subject: [PATCH] dc395x.h: use bitops.h BIT macro
Date: Thu, 1 Oct 2009 19:28:18 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901DB7421@mi8nycmail19.Mi8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod6og101.obsmtp.com ([64.18.1.181]:38553 "HELO
	exprod6og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751657AbZJAXfV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2009 19:35:21 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: oliver@neukum.name, aliakc@web.de, lenehan@twibble.org, James.Bottomley@suse.de

Use BIT macro from linux/bitops.h instead of custom defines.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Oliver Neukum <oliver@neukum.name>
Cc: Ali Akcaagac <aliakc@web.de>
Cc: Jamie Lenehan <lenehan@twibble.org>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>

---

This patch was originally posted to the linux-kernel list on
Aug 14, 2009.  Oliver Neukum said it looked good to him but it
needed to be posted to the scsi list.


diff --git a/drivers/scsi/dc395x.h b/drivers/scsi/dc395x.h
index b38360e..a448f5d 100644
--- a/drivers/scsi/dc395x.h
+++ b/drivers/scsi/dc395x.h
@@ -41,49 +41,17 @@
 /*	Various definitions						*/
 /*									*/
 /************************************************************************/
-#define BIT31				0x80000000
-#define BIT30				0x40000000
-#define BIT29				0x20000000
-#define BIT28				0x10000000
-#define BIT27				0x08000000
-#define BIT26				0x04000000
-#define BIT25				0x02000000
-#define BIT24				0x01000000
-#define BIT23				0x00800000
-#define BIT22				0x00400000
-#define BIT21				0x00200000
-#define BIT20				0x00100000
-#define BIT19				0x00080000
-#define BIT18				0x00040000
-#define BIT17				0x00020000
-#define BIT16				0x00010000
-#define BIT15				0x00008000
-#define BIT14				0x00004000
-#define BIT13				0x00002000
-#define BIT12				0x00001000
-#define BIT11				0x00000800
-#define BIT10				0x00000400
-#define BIT9				0x00000200
-#define BIT8				0x00000100
-#define BIT7				0x00000080
-#define BIT6				0x00000040
-#define BIT5				0x00000020
-#define BIT4				0x00000010
-#define BIT3				0x00000008
-#define BIT2				0x00000004
-#define BIT1				0x00000002
-#define BIT0				0x00000001
 
 /* UnitCtrlFlag */
-#define UNIT_ALLOCATED			BIT0
-#define UNIT_INFO_CHANGED		BIT1
-#define FORMATING_MEDIA			BIT2
-#define UNIT_RETRY			BIT3
+#define UNIT_ALLOCATED			BIT(0)
+#define UNIT_INFO_CHANGED		BIT(1)
+#define FORMATING_MEDIA			BIT(2)
+#define UNIT_RETRY			BIT(3)
 
 /* UnitFlags */
-#define DASD_SUPPORT			BIT0
-#define SCSI_SUPPORT			BIT1
-#define ASPI_SUPPORT			BIT2
+#define DASD_SUPPORT			BIT(0)
+#define SCSI_SUPPORT			BIT(1)
+#define ASPI_SUPPORT			BIT(2)
 
 /* SRBState machine definition */
 #define SRB_FREE			0x0000
@@ -117,29 +85,29 @@
 #define HCC_UP8TERM			0x01
 
 /* ACBFlag */
-#define RESET_DEV			BIT0
-#define RESET_DETECT			BIT1
-#define RESET_DONE			BIT2
+#define RESET_DEV			BIT(0)
+#define RESET_DETECT			BIT(1)
+#define RESET_DONE			BIT(2)
 
 /* DCBFlag */
-#define ABORT_DEV_			BIT0
+#define ABORT_DEV_			BIT(0)
 
 /* SRBstatus */
-#define SRB_OK				BIT0
-#define ABORTION			BIT1
-#define OVER_RUN			BIT2
-#define UNDER_RUN			BIT3
-#define PARITY_ERROR			BIT4
-#define SRB_ERROR			BIT5
+#define SRB_OK				BIT(0)
+#define ABORTION			BIT(1)
+#define OVER_RUN			BIT(2)
+#define UNDER_RUN			BIT(3)
+#define PARITY_ERROR			BIT(4)
+#define SRB_ERROR			BIT(5)
 
 /* SRBFlag */
-#define DATAOUT				BIT7
-#define DATAIN				BIT6
-#define RESIDUAL_VALID			BIT5
-#define ENABLE_TIMER			BIT4
-#define RESET_DEV0			BIT2
-#define ABORT_DEV			BIT1
-#define AUTO_REQSENSE			BIT0
+#define DATAOUT				BIT(7)
+#define DATAIN				BIT(6)
+#define RESIDUAL_VALID			BIT(5)
+#define ENABLE_TIMER			BIT(4)
+#define RESET_DEV0			BIT(2)
+#define ABORT_DEV			BIT(1)
+#define AUTO_REQSENSE			BIT(0)
 
 /* Adapter status */
 #define H_STATUS_GOOD			0
@@ -170,13 +138,13 @@
 
 /* Sync_Mode */
 #define SYNC_WIDE_TAG_ATNT_DISABLE	0
-#define SYNC_NEGO_ENABLE		BIT0
-#define SYNC_NEGO_DONE			BIT1
-#define WIDE_NEGO_ENABLE		BIT2
-#define WIDE_NEGO_DONE			BIT3
-#define WIDE_NEGO_STATE			BIT4
-#define EN_TAG_QUEUEING			BIT5
-#define EN_ATN_STOP			BIT6
+#define SYNC_NEGO_ENABLE		BIT(0)
+#define SYNC_NEGO_DONE			BIT(1)
+#define WIDE_NEGO_ENABLE		BIT(2)
+#define WIDE_NEGO_DONE			BIT(3)
+#define WIDE_NEGO_STATE			BIT(4)
+#define EN_TAG_QUEUEING			BIT(5)
+#define EN_ATN_STOP			BIT(6)
 
 #define SYNC_NEGO_OFFSET		15
 
@@ -626,12 +594,12 @@ struct ScsiInqData
 /*									*/
 /************************************************************************/
 #if 0
-#define MORE2_DRV			BIT0
-#define GREATER_1G			BIT1
-#define RST_SCSI_BUS			BIT2
-#define ACTIVE_NEGATION			BIT3
-#define NO_SEEK				BIT4
-#define LUN_CHECK			BIT5
+#define MORE2_DRV			BIT(0)
+#define GREATER_1G			BIT(1)
+#define RST_SCSI_BUS			BIT(2)
+#define ACTIVE_NEGATION			BIT(3)
+#define NO_SEEK				BIT(4)
+#define LUN_CHECK			BIT(5)
 #endif
 
 /************************************************************************/ 
