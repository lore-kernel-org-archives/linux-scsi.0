From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 4/4] scsi: megaraid_sas - version and documentation update
Date: Sun, 6 Dec 2009 08:42:28 -0700
Message-ID: <4B6A08C587958942AA3002690DD4F8C3B7EAC2CE@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C35C5123FA@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C35C6861A5@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C3B7EAC2C7@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C3B7EAC2C9@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933878AbZLFPmc@vger.kernel.org>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C3B7EAC2C9@cosmail02.lsi.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Austria, Winston" <Winston.Austria@lsi.com>, "Mukker, Atul" <Atul.Mukker@lsi.com>
List-Id: linux-scsi@vger.kernel.org

Update the version and documentation.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
Documentation/scsi/ChangeLog.megaraid_sas |   16 ++++++++++++++++
 drivers/scsi/megaraid/megaraid_sas.c      |    2 +-
 drivers/scsi/megaraid/megaraid_sas.h      |    6 +++---
 3 files changed, 20 insertions(+), 4 deletions(-)

diff -rupN old/Documentation/scsi/ChangeLog.megaraid_sas new/Documentation/scsi/ChangeLog.megaraid_sas
--- old/Documentation/scsi/ChangeLog.megaraid_sas	2009-12-06 04:53:06.000000000 -0500
+++ new/Documentation/scsi/ChangeLog.megaraid_sas	2009-12-06 05:10:00.000000000 -0500
@@ -1,3 +1,19 @@
+1 Release Date    : Thur.  Oct 29, 2009 09:12:45 PST 2009 -
+			(emaild-id:megaraidlinux@lsi.com)
+			Bo Yang
+
+2 Current Version : 00.00.04.17.1-rc1
+3 Older Version   : 00.00.04.12
+
+1.	Add the pad_0 in mfi frame structure to 0 to fix the
+	context value larger than 32bit value issue.
+
+2.	Add the logic drive list to the driver.  Driver will
+	keep the logic drive list internal after driver load.
+
+3.	driver fixed the device update issue after get the AEN
+	PD delete/ADD, LD add/delete from FW.
+
 1 Release Date    : Tues.  July 28, 2009 10:12:45 PST 2009 -
 			(emaild-id:megaraidlinux@lsi.com)
 			Bo Yang
diff -rupN old/drivers/scsi/megaraid/megaraid_sas.c new/drivers/scsi/megaraid/megaraid_sas.c
--- old/drivers/scsi/megaraid/megaraid_sas.c	2009-12-06 04:53:06.000000000 -0500
+++ new/drivers/scsi/megaraid/megaraid_sas.c	2009-12-06 04:53:58.000000000 -0500
@@ -10,7 +10,7 @@
  *	   2 of the License, or (at your option) any later version.
  *
  * FILE		: megaraid_sas.c
- * Version     : v00.00.04.12-rc1
+ * Version     : v00.00.04.17.1-rc1
  *
  * Authors:
  *	(email-id : megaraidlinux@lsi.com)
diff -rupN old/drivers/scsi/megaraid/megaraid_sas.h new/drivers/scsi/megaraid/megaraid_sas.h
--- old/drivers/scsi/megaraid/megaraid_sas.h	2009-12-06 04:53:06.000000000 -0500
+++ new/drivers/scsi/megaraid/megaraid_sas.h	2009-12-06 05:12:28.000000000 -0500
@@ -18,9 +18,9 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"00.00.04.12-rc1"
-#define MEGASAS_RELDATE				"Sep. 17, 2009"
-#define MEGASAS_EXT_VERSION			"Thu Sep. 17 11:41:51 PST 2009"
+#define MEGASAS_VERSION			"00.00.04.17.1-rc1"
+#define MEGASAS_RELDATE			"Oct. 29, 2009"
+#define MEGASAS_EXT_VERSION		"Thu. Oct. 29, 11:41:51 PST 2009"
 
 /*
  * Device IDs
