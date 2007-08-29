From: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: [PATCH] SCSI:  Remove references to dead "st0x" and "tmc8xx" kernel
 parms.
Date: Wed, 29 Aug 2007 13:25:23 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0708291321480.29835@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nic.NetDirect.CA ([216.16.235.2]:46638 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbXH2RgF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Aug 2007 13:36:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@SteelEye.com>


Since these two kernel parameters don't appear to be supported, remove
the useless references to them.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

 Documentation/kernel-parameters.txt |    6 ------
 drivers/scsi/seagate.c              |   11 -----------
 2 files changed, 17 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index b41cde3..9f2638c 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1766,9 +1766,6 @@ and is between 256 and 4096 characters. It is defined in the file
 	st=		[HW,SCSI] SCSI tape parameters (buffers, etc.)
 			See Documentation/scsi/st.txt.

-	st0x=		[HW,SCSI]
-			See header of drivers/scsi/seagate.c.
-
 	sti=		[PARISC,HW]
 			Format: <num>
 			Set the STI (builtin display/keyboard on the HP-PARISC
@@ -1853,9 +1850,6 @@ and is between 256 and 4096 characters. It is defined in the file
 	tipar.delay=	[HW,PPT]
 			Set inter-bit delay in microseconds (default 10).

-	tmc8xx=		[HW,SCSI]
-			See header of drivers/scsi/seagate.c.
-
 	tmscsim=	[HW,SCSI]
 			See comment before function dc390_setup() in
 			drivers/scsi/tmscsim.c.
diff --git a/drivers/scsi/seagate.c b/drivers/scsi/seagate.c
index ce80fa9..900f7d6 100644
--- a/drivers/scsi/seagate.c
+++ b/drivers/scsi/seagate.c
@@ -32,17 +32,6 @@
  * Configuration :
  * To use without BIOS -DOVERRIDE=base_address -DCONTROLLER=FD or SEAGATE
  * -DIRQ will override the default of 5.
- * Note: You can now set these options from the kernel's "command line".
- * The syntax is:
- *
- *     st0x=ADDRESS,IRQ                (for a Seagate controller)
- * or:
- *     tmc8xx=ADDRESS,IRQ              (for a TMC-8xx or TMC-950 controller)
- * eg:
- *     tmc8xx=0xC8000,15
- *
- * will configure the driver for a TMC-8xx style controller using IRQ 15
- * with a base address of 0xC8000.
  *
  * -DARBITRATE
  *      Will cause the host adapter to arbitrate for the
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
