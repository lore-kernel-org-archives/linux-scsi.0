From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] scsi/dpt_i2o.c: fix compilation on ia64
Date: Tue, 10 Jun 2008 01:26:31 +0300
Message-ID: <20080609222631.GX1987@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp4.pp.htv.fi ([213.243.153.38]:54212 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761682AbYFIW10 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Jun 2008 18:27:26 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <Mark_Salyzyn@adaptec.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This patch fixes the following compile error:

<--  snip  -->

...
  CC      drivers/scsi/dpt_i2o.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/scsi/dpt_i2o.c:83: error: 'PROC_IA64' undeclared here (not in a function)
make[3]: *** [drivers/scsi/dpt_i2o.o] Error 1

<--  snip  -->

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
631dedfbf9e2a9720dd6ecd382c0568372c3e436 diff --git a/drivers/scsi/dpt/dptsig.h b/drivers/scsi/dpt/dptsig.h
index 72c8992..01cd528 100644
--- a/drivers/scsi/dpt/dptsig.h
+++ b/drivers/scsi/dpt/dptsig.h
@@ -92,6 +92,7 @@ typedef unsigned int sigINT;
 #define PROC_POWERPC    0x04    /* IBM Power PC */
 #define PROC_i960       0x05    /* Intel i960 */
 #define PROC_ULTRASPARC 0x06    /* SPARC processor */
+#define PROC_IA64       0x07    /* ia64 processor */
 
 /* Specific Minimim Processor - sigBYTE dsProcessor;    FLAG BITS */
 /* ------------------------------------------------------------------ */

