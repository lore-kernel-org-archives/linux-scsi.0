From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: Question on qla2xxx Kconfig update in 2.6.2
Date: Thu, 5 Feb 2004 09:49:00 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B0598EAD@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [198.70.193.2] ([198.70.193.2]:23848 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S266516AbUBERso convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Feb 2004 12:48:44 -0500
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Mike Anderson <andmike@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thursday, February 05, 2004 8:55 AM, James Bottomley wrote:
> On Thu, 2004-02-05 at 11:58, Mike Anderson wrote:
> > Should we fix it the other way around (i.e., have qla2xxx Kconfig
> > use SCSI_QLA2XXX) to be consistent with other Kconfig users. I see
> > only one other in the .config file that I am using that has a
> > _CONFIG postfix. 
> 
> Well, least line of resistance when things don't work.
> 
> But I agree, removing the _CONFIG in qla2xxx/Kconfig does look better.
> 
> James

David Miller had already sent along a patch to me which removes the 
_CONFIG suffix.  I'll attach it here.

--
Andrew Vasquez


===== drivers/scsi/qla2xxx/Kconfig 1.4 vs edited =====
--- 1.4/drivers/scsi/qla2xxx/Kconfig	Mon Feb  2 08:02:05 2004
+++ edited/drivers/scsi/qla2xxx/Kconfig	Wed Feb  4 21:31:12 2004
@@ -1,41 +1,41 @@
-config SCSI_QLA2XXX_CONFIG
+config SCSI_QLA2XXX
 	tristate
 	default (SCSI && PCI)
 	depends on SCSI && PCI
 
 config SCSI_QLA21XX
 	tristate "QLogic ISP2100 host adapter family support"
-	depends on SCSI_QLA2XXX_CONFIG
+	depends on SCSI_QLA2XXX
 	---help---
 	This driver supports the QLogic 21xx (ISP2100) host adapter family.
 
 config SCSI_QLA22XX
 	tristate "QLogic ISP2200 host adapter family support"
-	depends on SCSI_QLA2XXX_CONFIG
+	depends on SCSI_QLA2XXX
 	---help---
 	This driver supports the QLogic 22xx (ISP2200) host adapter family.
 
 config SCSI_QLA2300
 	tristate "QLogic ISP2300 host adapter family support"
-	depends on SCSI_QLA2XXX_CONFIG
+	depends on SCSI_QLA2XXX
 	---help---
 	This driver supports the QLogic 2300 (ISP2300, and ISP2312) host
 	adapter family.
 
 config SCSI_QLA2322
 	tristate "QLogic ISP2322 host adapter family support"
-	depends on SCSI_QLA2XXX_CONFIG
+	depends on SCSI_QLA2XXX
 	---help---
 	This driver supports the QLogic 2322 (ISP2322) host adapter family.
 
 config SCSI_QLA6312
 	tristate "QLogic ISP6312 host adapter family support"
-	depends on SCSI_QLA2XXX_CONFIG
+	depends on SCSI_QLA2XXX
 	---help---
 	This driver supports the QLogic 6312 (ISP6312) host adapter family.
 
 config SCSI_QLA6322
 	tristate "QLogic ISP6322 host adapter family support"
-	depends on SCSI_QLA2XXX_CONFIG
+	depends on SCSI_QLA2XXX
 	---help---
 	This driver supports the QLogic 6322 (ISP6322) host adapter family.
