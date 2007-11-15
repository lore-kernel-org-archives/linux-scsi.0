From: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: [PATCH] Documentation:  Remove references to dead "st0x" and "tmc8xx"
 parms.
Date: Wed, 14 Nov 2007 23:36:53 -0500 (EST)
Message-ID: <alpine.LFD.0.9999.0711142335060.15148@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:33735 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbXKOEka (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Nov 2007 23:40:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: trivial@kernel.org
Cc: linux-scsi@vger.kernel.org


Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  as best i can tell, those kernel parms don't exist anymore.

 Documentation/kernel-parameters.txt |    6 ------
 drivers/scsi/seagate.c              |   11 -----------
 2 files changed, 17 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 33121d6..8f4f8ee 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1813,9 +1813,6 @@ and is between 256 and 4096 characters. It is defined in the file
 	st=		[HW,SCSI] SCSI tape parameters (buffers, etc.)
 			See Documentation/scsi/st.txt.

-	st0x=		[HW,SCSI]
-			See header of drivers/scsi/seagate.c.
-
 	sti=		[PARISC,HW]
 			Format: <num>
 			Set the STI (builtin display/keyboard on the HP-PARISC
@@ -1900,9 +1897,6 @@ and is between 256 and 4096 characters. It is defined in the file
 	tipar.delay=	[HW,PPT]
 			Set inter-bit delay in microseconds (default 10).

-	tmc8xx=		[HW,SCSI]
-			See header of drivers/scsi/seagate.c.
-
 	tmscsim=	[HW,SCSI]
 			See comment before function dc390_setup() in
 			drivers/scsi/tmscsim.c.
diff --git a/drivers/scsi/seagate.c b/drivers/scsi/seagate.c
index b113244..d6f38f7 100644
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

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
