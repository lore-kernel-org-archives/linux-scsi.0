From: Rolf Eike Beer <eike@bilbo.math.uni-mannheim.de>
Subject: [PATCH 2/2] clean up scsi documentation
Date: Mon, 11 Nov 2002 16:53:02 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211111653.02208@bilbo.math.uni-mannheim.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

And here are the final cleanups.

Eike

diff -Naur linux-2.5.47-scsi-doc-moved/Documentation/scsi/ChangeLog.sym53c8xx_2 linux-2.5.47-scsi-doc-moved-cleaned/Documentation/scsi/ChangeLog.sym53c8xx_2
--- linux-2.5.47-scsi-doc-moved/Documentation/scsi/ChangeLog.sym53c8xx_2	Mon Nov 11 08:17:20 2002
+++ linux-2.5.47-scsi-doc-moved-cleaned/Documentation/scsi/ChangeLog.sym53c8xx_2	Mon Nov 11 08:53:53 2002
@@ -142,7 +142,3 @@
 	  consistent with what archs are expecting.
 	- Use MMIO per default for Power PC instead of some fake normal IO,
 	  as Paul Mackerras stated that MMIO works fine now on this arch.
-
-
-
-
diff -Naur linux-2.5.47-scsi-doc-moved/Documentation/scsi/FlashPoint.txt linux-2.5.47-scsi-doc-moved-cleaned/Documentation/scsi/FlashPoint.txt
--- linux-2.5.47-scsi-doc-moved/Documentation/scsi/FlashPoint.txt	Mon Nov 11 08:17:20 2002
+++ linux-2.5.47-scsi-doc-moved-cleaned/Documentation/scsi/FlashPoint.txt	Mon Nov 11 08:53:53 2002
@@ -60,7 +60,7 @@
 Mylex Corp.
 510/796-6100
 peters@mylex.com
-
+
 			       ANNOUNCEMENT
 	       BusLogic FlashPoint LT/BT-948 Upgrade Program
 			      1 February 1996
diff -Naur linux-2.5.47-scsi-doc-moved/Documentation/scsi/cpqfc.txt linux-2.5.47-scsi-doc-moved-cleaned/Documentation/scsi/cpqfc.txt
--- linux-2.5.47-scsi-doc-moved/Documentation/scsi/cpqfc.txt	Mon Nov 11 08:17:20 2002
+++ linux-2.5.47-scsi-doc-moved-cleaned/Documentation/scsi/cpqfc.txt	Mon Nov 11 08:53:53 2002
@@ -100,8 +100,6 @@
 using "qa_test" (esp. io_test script) suite modified from Unix tests.
 	
 Installation:
-copy file cpqfcTS.patch to /usr/src/linux
-patch -p1 < cpqfcTS.patch
 make menuconfig
   (select SCSI low-level, Compaq FC HBA)
 make dep
diff -Naur linux-2.5.47-scsi-doc-moved/Documentation/scsi/dtc3x80.txt linux-2.5.47-scsi-doc-moved-cleaned/Documentation/scsi/dtc3x80.txt
--- linux-2.5.47-scsi-doc-moved/Documentation/scsi/dtc3x80.txt	Mon Nov 11 08:17:20 2002
+++ linux-2.5.47-scsi-doc-moved-cleaned/Documentation/scsi/dtc3x80.txt	Mon Nov 11 08:53:53 2002
@@ -41,5 +41,3 @@
 nowhere, I give up.  So.....This driver does NOT use interrupts, even
 if you have the card jumpered to an IRQ.  Probably nobody will ever
 care.
-
-
diff -Naur linux-2.5.47-scsi-doc-moved/Documentation/scsi/qlogicisp.txt linux-2.5.47-scsi-doc-moved-cleaned/Documentation/scsi/qlogicisp.txt
--- linux-2.5.47-scsi-doc-moved/Documentation/scsi/qlogicisp.txt	Mon Nov 11 08:17:20 2002
+++ linux-2.5.47-scsi-doc-moved-cleaned/Documentation/scsi/qlogicisp.txt	Mon Nov 11 08:53:53 2002
@@ -28,7 +28,3 @@
 Revised:
 Michael A. Griffith
 grif@cs.ucr.edu
-
-
-
-
