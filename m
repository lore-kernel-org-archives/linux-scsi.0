From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 9/9] scsi: megaraid_sas - Update the Version and ChangeLog
Date: Tue, 17 Feb 2009 10:50:22 -0700
Message-ID: <4B6A08C587958942AA3002690DD4F8C33A07FC71@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C33A07FC5B@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og102.obsmtp.com ([64.18.2.157]:55471 "EHLO
	exprod7og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbZBQRup convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Feb 2009 12:50:45 -0500
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C33A07FC5B@cosmail02.lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>li
Cc: "Austria, Winston" <Winston.Austria@lsi.com>

Update the Version and ChangeLog

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
Documentation/scsi/ChangeLog.megaraid_sas |   25 +++++++++++++++++++++++++
 drivers/scsi/megaraid/megaraid_sas.c      |    2 +-
 drivers/scsi/megaraid/megaraid_sas.h      |    6 +++---
 3 files changed, 29 insertions(+), 4 deletions(-)

diff -rupN linux-2.6.28_orig/Documentation/scsi/ChangeLog.megaraid_sas linux-2.6.28_new/Documentation/scsi/ChangeLog.megaraid_sas
--- linux-2.6.28_orig/Documentation/scsi/ChangeLog.megaraid_sas 2009-02-12 17:30:44.000000000 -0500
+++ linux-2.6.28_new/Documentation/scsi/ChangeLog.megaraid_sas  2009-02-12 15:24:58.000000000 -0500
@@ -1,4 +1,29 @@

+1 Release Date    : Tues. Feb. 10, 2009 10:12:45 PST 2009 -
+                        (emaild-id:megaraidlinux@lsi.com)
+                        Bo Yang
+
+2 Current Version : 00.00.04.03
+3 Older Version   : 00.00.04.01
+
+1.     Add the Tape drive fix to the driver: If the command is for the tape device, set the
+       pthru timeout to the os layer timeout value.
+
+2.     Add Poll_wait mechanism to Gen-2 Linux driv.
+               In the aen handler, driver needs to wakeup poll handler similar to the way it raises SIGIO.
+               Driver needs to reregister for AEN with the FW when it receives AEN. This will ensure AEN
+               continuity and avoid depending upon storelib to continue events.
+
+3.     Add new controller 0x73(new SAS2)  support to the driver.
+
+4.     Add memory support required by 0x73 controller.
+
+5.     Report the unconfigured PD (system PD) to OS.
+
+6.     Add the IEEE SGL support to the driver
+
+7.     Reasign the Application cmds to 0x73 controller
+
 1 Release Date    : Thur.July. 24 11:41:51 PST 2008 -
                        (emaild-id:megaraidlinux@lsi.com)
                        Sumant Patro
diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c      2009-02-12 17:30:45.000000000 -0500
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c       2009-02-12 17:31:58.000000000 -0500
@@ -10,7 +10,7 @@
  *        2 of the License, or (at your option) any later version.
  *
  * FILE                : megaraid_sas.c
- * Version     : v00.00.04.01-rc1
+ * Version     : v00.00.04.03-rc1
  *
  * Authors:
  *     (email-id : megaraidlinux@lsi.com)
diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h      2009-02-12 17:30:47.000000000 -0500
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h       2009-02-12 17:32:44.000000000 -0500
@@ -18,9 +18,9 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION                                "00.00.04.01"
-#define MEGASAS_RELDATE                                "July 24, 2008"
-#define MEGASAS_EXT_VERSION                    "Thu July 24 11:41:51 PST 2008"
+#define MEGASAS_VERSION                                "00.00.04.03-rc1"
+#define MEGASAS_RELDATE                                "Feb. 10, 2009"
+#define MEGASAS_EXT_VERSION                    "Tues Feb. 10 11:41:51 PST 2009"

 /*
  * Device IDs
