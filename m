From: Petros Koutoupis <petros@petroskoutoupis.com>
Subject: scsi_common: Modify SMR device type to reflect SCSI specification
Date: Sat, 21 May 2016 20:58:39 -0500
Message-ID: <1463882319.4525.3.camel@petros-ultrathin>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.196]:60393 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbcEVB6u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 May 2016 21:58:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: "petros@petroskoutoupis.com" <petros@petroskoutoupis.com>

This change is purely cosmetic but we should adjust device type 0x14 to
reflect the definition given in the SCSI specification standard (SPC-5).

Implying Direct-Access assumes that the device supports the traditional
Direct-Access command set when Host Managed Zoned Block Devices support
a subset of that command set with a few zone specific additions. Please
refer to the ZBC for details.

Signed-off-by: Petros Koutoupis <petros@petroskoutoupis.com>

--- linux/drivers/scsi/scsi_common.c.orig	2016-05-12 12:23:04.450000000 -0500
+++ linux/drivers/scsi/scsi_common.c	2016-05-12 12:29:08.382000000 -0500
@@ -14,27 +14,27 @@
  * encouraged once assigned by ANSI/INCITS T10
  */
 static const char *const scsi_device_types[] = {
-	"Direct-Access    ",
-	"Sequential-Access",
-	"Printer          ",
-	"Processor        ",
-	"WORM             ",
-	"CD-ROM           ",
-	"Scanner          ",
-	"Optical Device   ",
-	"Medium Changer   ",
-	"Communications   ",
-	"ASC IT8          ",
-	"ASC IT8          ",
-	"RAID             ",
-	"Enclosure        ",
-	"Direct-Access-RBC",
-	"Optical card     ",
-	"Bridge controller",
-	"Object storage   ",
-	"Automation/Drive ",
-	"Security Manager ",
-	"Direct-Access-ZBC",
+	"Direct-Access     ",
+	"Sequential-Access ",
+	"Printer           ",
+	"Processor         ",
+	"WORM              ",
+	"CD-ROM            ",
+	"Scanner           ",
+	"Optical Device    ",
+	"Medium Changer    ",
+	"Communications    ",
+	"ASC IT8           ",
+	"ASC IT8           ",
+	"RAID              ",
+	"Enclosure         ",
+	"Direct-Access-RBC ",
+	"Optical card      ",
+	"Bridge controller ",
+	"Object storage    ",
+	"Automation/Drive  ",
+	"Security Manager  ",
+	"Host Managed Zoned",
 };
 
 /**


