From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [2.6 patch] SCSI_AACRAID: add a help text
Date: Fri, 4 Nov 2005 08:35:29 -0500
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F01D127E0@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932739AbVKDNfc@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-kernel-owner@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

It's a good start! I approve. The time stamp and kernel version must
have come out of a rift though ;->

The web page covers a broad line of our products, many of which are
*not* aacraid based. No big deal, but I must admit Adaptec has not
placed a clear delineation. All late model RAID cards from Adaptec are
based on the aacraid interface.

Dell CERC, IBM ServeRAID 7t, 8i & 8k and ICP 9014, 9024, 9047, 9087,
5085, 9085 & 9067 SATA and SAS cards are missing.

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

--- linux-2.6.6/drivers/scsi/Kconfig        2004-05-17
20:55:52.074925760 -0500
+++ linux-2.6.6/drivers/scsi/Kconfig.new    2005-10-4 08:28:09
@@ -318,6 +318,7 @@
 	help
 	  This driver supports the Dell PERC2, 2/Si, 3/Si, 3/Di,
-	  HP NetRAID-4M SCSI and the Adaptec Advanced Raid Products
+	  CERC, HP NetRAID-4M SCSI, Adaptec Advanced Raid Products
 	  <http://www.adaptec.com/products/solutions/raid.html>
+	  late model IBM ServeRAID and ICP SATA & SAS products.
 
 	  To compile this driver as a module, choose M here: the module

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Adrian Bunk
Sent: Thursday, November 03, 2005 8:01 PM
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] SCSI_AACRAID: add a help text

Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.6/drivers/scsi/Kconfig.old        2004-05-17
20:51:21.395075352 -0500
+++ linux-2.6.6/drivers/scsi/Kconfig    2004-05-17 20:55:52.074925760
-0500
@@ -315,6 +315,13 @@
 config SCSI_AACRAID
 	tristate "Adaptec AACRAID support"
 	depends on SCSI && PCI
+	help
+	  This driver supports the Dell PERC2, 2/Si, 3/Si, 3/Di,
+	  HP NetRAID-4M SCSI and the Adaptec Advanced Raid Products
+	  <http://www.adaptec.com/products/solutions/raid.html>
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called aacraid.

 source "drivers/scsi/aic7xxx/Kconfig.aic7xxx"
