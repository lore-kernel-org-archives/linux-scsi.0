From: "nickcheng" <nick.cheng@areca.com.tw>
Subject: [PATCH] scsi: upstream arcmsr-1.20.00.15-80227
Date: Wed, 27 Feb 2008 16:22:03 +0800
Message-ID: <003501c87919$d4d6f660$8800a8c0@Nick>
Reply-To: <nick.cheng@areca.com.tw>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0036_01C8795C.E2FA3660"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from areca.com.tw ([220.130.178.142]:53720 "EHLO areca.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798AbYB0IWG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Feb 2008 03:22:06 -0500
In-Reply-To: 
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nick.cheng@areca.com.tw, 'Andrew Morton' <akpm@linux-foundation.org>, James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, randy.dunlap@oracle.com, billion.wu@areca.com.tw, 'erich' <erich@areca.com.tw>

This is a multi-part message in MIME format.

------=_NextPart_000_0036_01C8795C.E2FA3660
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit

Subject: [PATCH] scsi: upstream arcmsr-1.20.00.15-80227
From: Nick Cheng <nick.cheng@areca.com.tw>
Description:
*** update the driver version of arcmsr and ChangeLog.arcmsr
Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>

------=_NextPart_000_0036_01C8795C.E2FA3660
Content-Type: text/plain;
	name="patch_arcmsr-1.20.00.15-80227.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch_arcmsr-1.20.00.15-80227.txt"

diff --git a/Documentation/scsi/ChangeLog.arcmsr =
b/Documentation/scsi/ChangeLog.arcmsr
index de2bcac..038a3e6 100644
--- a/Documentation/scsi/ChangeLog.arcmsr
+++ b/Documentation/scsi/ChangeLog.arcmsr
@@ -109,4 +109,10 @@
 **						8.replace pci_alloc_consistent()/pci_free_consistent() with =
kmalloc()/kfree() in arcmsr_iop_message_xfer()
 **						9. fix the release of dma memory for type B in =
arcmsr_free_ccb_pool()
 **						10.fix the arcmsr_polling_hbb_ccbdone()
+** 1.20.00.15	02/27/2008	Erich Chen & Nick Cheng
+**						1.arcmsr_iop_message_xfer() is called from atomic context under =
the
+**						queuecommand scsi_host_template handler. James Bottomley =
pointed out
+**						that the current GFP_KERNEL|GFP_DMA flags are wrong: firstly we =
are in
+**						atomic context, secondly this memory is not used for DMA.
+**						Also removed some unneeded casts. Thanks to Daniel Drake =
<dsd@gentoo.org>
 =
*************************************************************************=
*
diff --git a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
index 5778650..0393707 100644
--- a/drivers/scsi/arcmsr/arcmsr.h
+++ b/drivers/scsi/arcmsr/arcmsr.h
@@ -48,7 +48,7 @@ struct class_device_attribute;
 /*The limit of outstanding scsi command that firmware can handle*/
 #define ARCMSR_MAX_OUTSTANDING_CMD						256
 #define ARCMSR_MAX_FREECCB_NUM							320
-#define ARCMSR_DRIVER_VERSION		     "Driver Version 1.20.00.15 =
2007/12/24"
+#define ARCMSR_DRIVER_VERSION		     "Driver Version 1.20.00.15 =
2008/02/27"
 #define ARCMSR_SCSI_INITIATOR_ID						255
 #define ARCMSR_MAX_XFER_SECTORS							512
 #define ARCMSR_MAX_XFER_SECTORS_B						4096

------=_NextPart_000_0036_01C8795C.E2FA3660--

