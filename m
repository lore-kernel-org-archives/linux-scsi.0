From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 1/11] [SYM2] Remove FreeBSD ifdefs
Date: Tue, 29 Nov 2005 23:08:27 -0500 (EST)
Message-ID: <20051130040827.924C07626C@gonzo>
References: <20051130040537.GC1597@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2-old.magma.ca ([206.191.0.250]:54462 "EHLO mx2.magma.ca")
	by vger.kernel.org with ESMTP id S1750840AbVK3EIe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Nov 2005 23:08:34 -0500
Received: from mail1.magma.ca (mail1.magma.ca [206.191.0.252])
	by mx2.magma.ca (8.13.0/8.13.0) with ESMTP id jAU48WtB014230
	for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2005 23:08:33 -0500
Received: from gonzo (ottawa-hs-209-217-123-220.d-ip.magma.ca [209.217.123.220])
	by mail1.magma.ca (8.13.0/8.13.0) with ESMTP id jAU48RaY000513
	for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2005 23:08:32 -0500
In-Reply-To: <20051130040537.GC1597@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Remove FreeBSD ifdefs from sym2 driver

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

---

 drivers/scsi/sym53c8xx_2/sym_fw.c     |   12 ------------
 drivers/scsi/sym53c8xx_2/sym_malloc.c |    4 ----
 2 files changed, 0 insertions(+), 16 deletions(-)

applies-to: 980297c1747ca89354bc879cc5d17903eacb19e2
2af497794dd514ee3ea22fd6de7f62efbdd296b4
diff --git a/drivers/scsi/sym53c8xx_2/sym_fw.c b/drivers/scsi/sym53c8xx_2/sym_fw.c
index fd36cf9..a7528a8 100644
--- a/drivers/scsi/sym53c8xx_2/sym_fw.c
+++ b/drivers/scsi/sym53c8xx_2/sym_fw.c
@@ -37,11 +37,7 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
-#ifdef __FreeBSD__
-#include <dev/sym/sym_glue.h>
-#else
 #include "sym_glue.h"
-#endif
 
 /*
  *  Macros used for all firmwares.
@@ -60,11 +56,7 @@
 #define	SYM_FWA_SCR		sym_fw1a_scr
 #define	SYM_FWB_SCR		sym_fw1b_scr
 #define	SYM_FWZ_SCR		sym_fw1z_scr
-#ifdef __FreeBSD__
-#include <dev/sym/sym_fw1.h>
-#else
 #include "sym_fw1.h"
-#endif
 static struct sym_fwa_ofs sym_fw1a_ofs = {
 	SYM_GEN_FW_A(struct SYM_FWA_SCR)
 };
@@ -88,11 +80,7 @@ static struct sym_fwz_ofs sym_fw1z_ofs =
 #define	SYM_FWA_SCR		sym_fw2a_scr
 #define	SYM_FWB_SCR		sym_fw2b_scr
 #define	SYM_FWZ_SCR		sym_fw2z_scr
-#ifdef __FreeBSD__
-#include <dev/sym/sym_fw2.h>
-#else
 #include "sym_fw2.h"
-#endif
 static struct sym_fwa_ofs sym_fw2a_ofs = {
 	SYM_GEN_FW_A(struct SYM_FWA_SCR)
 };
diff --git a/drivers/scsi/sym53c8xx_2/sym_malloc.c b/drivers/scsi/sym53c8xx_2/sym_malloc.c
index a34d403..92bf9b1 100644
--- a/drivers/scsi/sym53c8xx_2/sym_malloc.c
+++ b/drivers/scsi/sym53c8xx_2/sym_malloc.c
@@ -37,11 +37,7 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
-#ifdef __FreeBSD__
-#include <dev/sym/sym_glue.h>
-#else
 #include "sym_glue.h"
-#endif
 
 /*
  *  Simple power of two buddy-like generic allocator.
---
0.99.9.GIT
