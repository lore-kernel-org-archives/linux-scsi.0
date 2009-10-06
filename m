From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 12/12] scsi: megaraid_sas - version and docs update
Date: Tue, 6 Oct 2009 14:55:09 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C35C70B212@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C35C5119E1@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C35C512408@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933384AbZJFU4C@vger.kernel.org>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C35C512408@cosmail02.lsi.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "Austria, Winston" <Winston.Austria@lsi.com>, "Mukker, Atul" <Atul.Mukker@lsi.com>
List-Id: linux-scsi@vger.kernel.org

RESUBMIT:

Update the version and documentation

Signed-off-by Bo Yang<bo.yang@lsi.com>

---

Documentation/scsi/ChangeLog.megaraid_sas |   62 ++++++++++++++++++++++++++++++
 drivers/scsi/megaraid/megaraid_sas.c      |    2
 drivers/scsi/megaraid/megaraid_sas.h      |    6 +-
 3 files changed, 66 insertions(+), 4 deletions(-)

diff -rupN linux-2.6.28_orig/Documentation/scsi/ChangeLog.megaraid_sas linux-2.6.28_new/Documentation/scsi/ChangeLog.megaraid_sas
--- linux-2.6.28_orig/Documentation/scsi/ChangeLog.megaraid_sas	2009-09-15 05:32:34.000000000 -0400
+++ linux-2.6.28_new/Documentation/scsi/ChangeLog.megaraid_sas	2009-09-15 06:12:38.000000000 -0400
@@ -1,3 +1,65 @@
+1 Release Date    : Tues.  July 28, 2009 10:12:45 PST 2009 -
+			(emaild-id:megaraidlinux@lsi.com)
+			Bo Yang
+
+2 Current Version : 00.00.04.12
+3 Older Version   : 00.00.04.10
+
+1.	Change the AEN sys PD update from scsi_scan to
+	scsi_add_device and scsi_remove_device.
+2.	Takeoff the debug print-out in aen_polling routine.
+
+1 Release Date    : Thur.  July 02, 2009 10:12:45 PST 2009 -
+			(emaild-id:megaraidlinux@lsi.com)
+			Bo Yang
+
+2 Current Version : 00.00.04.10
+3 Older Version   : 00.00.04.08
+
+1.	Add the 3 mins timeout during the controller initialize.
+2.	Add the fix for 64bit sense date errors.
+ 
+1 Release Date    : Tues. May 05, 2009 10:12:45 PST 2009 -
+			(emaild-id:megaraidlinux@lsi.com)
+			Bo Yang
+
+2 Current Version : 00.00.04.08
+3 Older Version   : 00.00.04.06
+
+1.	Add the fix of pending in FW after deleted the logic drives. 
+2.	Add the fix of deallocating memory after get pdlist.
+
+1 Release Date    : Tues. March 26, 2009 10:12:45 PST 2009 -
+			(emaild-id:megaraidlinux@lsi.com)
+			Bo Yang
+
+2 Current Version : 00.00.04.06
+3 Older Version   : 00.00.04.04
+
+1.	Add the fix of the driver cmd empty fix of the driver cmd empty. 
+2.	Add the fix of the driver MSM AEN CMD cause the system slow. 
+
+1 Release Date    : Tues. March 03, 2009 10:12:45 PST 2009 -
+			(emaild-id:megaraidlinux@lsi.com)
+			Bo Yang
+
+2 Current Version : 00.00.04.04
+3 Older Version   : 00.00.04.01
+
+1.	Add the Tape drive fix to the driver: If the command is for
+	the tape device, set the pthru timeout to the os layer timeout value.
+
+2.	Add Poll_wait mechanism to Gen-2 Linux driv.
+		In the aen handler, driver needs to wakeup poll handler similar to 
+		the way it raises SIGIO. 
+
+3.	Add new controller new SAS2 support to the driver.
+
+4.	Report the unconfigured PD (system PD) to OS.
+
+5.	Add the IEEE SGL support to the driver   
+
+6.	Reasign the Application cmds to SAS2 controller
 
 1 Release Date    : Thur.July. 24 11:41:51 PST 2008 -
                        (emaild-id:megaraidlinux@lsi.com)
diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c	2009-09-15 05:32:34.000000000 -0400
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c	2009-09-15 05:33:49.000000000 -0400
@@ -10,7 +10,7 @@
  *	   2 of the License, or (at your option) any later version.
  *
  * FILE		: megaraid_sas.c
- * Version     : v00.00.04.01-rc1
+ * Version     : v00.00.04.12-rc1
  *
  * Authors:
  *	(email-id : megaraidlinux@lsi.com)
diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h	2009-09-15 05:32:34.000000000 -0400
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h	2009-09-15 05:34:40.000000000 -0400
@@ -18,9 +18,9 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"00.00.04.01"
-#define MEGASAS_RELDATE				"July 24, 2008"
-#define MEGASAS_EXT_VERSION			"Thu July 24 11:41:51 PST 2008"
+#define MEGASAS_VERSION				"00.00.04.12-rc1"
+#define MEGASAS_RELDATE				"Sep. 17, 2009"
+#define MEGASAS_EXT_VERSION			"Thu Sep. 17 11:41:51 PST 2009"
 
 /*
  * Device IDs
