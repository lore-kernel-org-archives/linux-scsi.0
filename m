From: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>
Subject: Patch Kconfig for SCSI_MEGARAID: update list of supported hardware
Date: Fri, 20 Feb 2004 03:25:02 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m31xoqpjwh.fsf@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from krusty.dt.E-Technik.Uni-Dortmund.DE ([129.217.163.1]:45508 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S267691AbUBTCZF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Feb 2004 21:25:05 -0500
Received: from m2a2.dyndns.org (krusty.dt.e-technik.uni-dortmund.de [129.217.163.1])
	by mail.dt.e-technik.uni-dortmund.de (Postfix) with ESMTP id 40F7F1F934
	for <linux-scsi@vger.kernel.org>; Fri, 20 Feb 2004 03:25:04 +0100 (CET)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Please add the missing Series 418/531/532 marketing names and commit:

You can import this changeset into BK by piping this whole message to:
'| bk receive [path to repository]' or apply the patch as usual.

===================================================================


ChangeSet@1.1695, 2004-02-20 03:09:26+01:00, matthias.andree@gmx.de
  Update SCSI_MEGARAID option help to list all series that
  megaraid.c lists. Add marketing names where known,
  418, 531, 532 aren't known to me.


 Kconfig |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)


diff -Nru a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig	Fri Feb 20 03:13:54 2004
+++ b/drivers/scsi/Kconfig	Fri Feb 20 03:13:54 2004
@@ -377,11 +377,17 @@
 	  module will be called in2000.
 
 config SCSI_MEGARAID
-	tristate "AMI MegaRAID support"
+	tristate "AMI MegaRAID/LSI MegaRAID support"
 	depends on PCI && SCSI
 	help
-	  This driver supports the AMI MegaRAID 418, 428, 438, 466, 762, 490
-	  and 467 SCSI host adapters.
+	  This driver supports the LSI MegaRAID Series 418, 428, 438,
+	  466, 467, 471, 490, 493, 518, 520, 531, 532 and Series 762
+	  host adapters. These are also known as MegaRAID Elite 1500,
+	  Elite 1600, Enterprise 1200, Enterprise 1400, Enterprise 1600,
+	  Express 000, Express 200, Express 300, SCSI 320-0, SCSI 320-1,
+	  SCSI 320-1.
+
+	  FIXME: how are Series 418, 531, 532 called by LSI marketing?
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called megaraid.

===================================================================


This BitKeeper patch contains the following changesets:
1.1695
## Wrapped with gzip_b64 ##


H4sIAGJtNUAAA+VV227jNhB9Nr9isPvQh40lXiRKFuA23sS7NbJBg7gBCrRFQUtT
S2vdQDK3Qh9fUk7ibJC2aNE+1TZon/HMcOacA+gtXBnU2aRR1paVMoFqC41I3sK3
nbHZZNvcBYWHl13nYGiuDYY71C3W4fuzsK7a67spDyRxKRfK5iXcoDbZhAXiKWLv
e8wml8uPV58Wl4TM53BSqnaLa7QwnxPb6RtVF+ZY2bLu2sBq1ZoGrQryrhmeUgdO
KXfvmCWCxnJgkkbJkLOCMRUxLCiPUhkduvV9Pkto0JmiDjq9/bJRRLk7KY9ZPMgo
FjNyCixgchYDjULKQ06BiozOMi7fUZZRCi8YOt4zA+8YTCl5D//uFickh6u+UBZh
fbJe/XK+/Li4XKxOoett1bVQYt27K6GujAVV1+BErNCALZV1pQ1ulVZVEeRjhglg
URRuA71DW7VbaFXjkm9L1Ai7trttj1xRxNIjiAXzBwelsf3K7v/1NzUYkDOQEYti
cnEQkEz/5osQqij5Gn6r+h7r472BGpnuvEg/PrL481DoyjspNLmpwrO8a3+ttiN5
jAqnn+AiGqhwKg5JnDIlZLqJOFUbJ8nrSv1hx70XOBWCD0zMZmK06GvZ3q3/3dzk
M37eHGt1g21Q1YGxiDXe4+ifP5mdJkyKlNIhTmTKRx/HL1wsMsH/wsUzmIr/jYv3
Kn8HU307fpwrL14V/B+4+9RpAYys9l8Tq93knoA3i/MVnLuNPAHhp/UBgLnu+07b
N75WAPe1EaRkAvB9WZmHwR6zPDsIX9Sv96yNm0fcHyI98uWRlA7IxB2JIySaUX8I
R81IEqfPmWqLx0aJ5L667LwqheqtoyVws6BBT6hTynQPlCpzGGNZV25PFlM6Xv4A
pYOwbF2P3lHhAvxlIHoZkI8d7nqNxgAdEx4Afw6EB95aIDidPv/Nxg4HGJCffODD
6ofzZeZWux03ec7cExO5cyIWsLkfWX6y2zeHR1xeYr4z1818o1hKpRDkd5omcVZH
BwAA

-- 
Matthias Andree

Encrypt your mail: my GnuPG key ID is 0x052E7D95
