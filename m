From: Andrew Vasquez <praka@users.sourceforge.net>
Subject: Re: PATCH [14/18] qla2xxx: Use proper include files
Date: Tue, 22 Jun 2004 15:22:01 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040622222201.GA16981@praka.san.rr.com>
References: <B179AE41C1147041AA1121F44614F0B0DD027D@AVEXCH02.qlogic.org> <20040622172207.GB6074@infradead.org> <20040622174900.GA14887@praka.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-01-qfe0.socal.rr.com ([66.75.162.133]:51653 "EHLO
	ms-smtp-01-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S266014AbUFVWaO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jun 2004 18:30:14 -0400
Content-Disposition: inline
In-Reply-To: <20040622174900.GA14887@praka.san.rr.com>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>

On Tue, 22 Jun 2004, Andrew Vasquez wrote:

> Yes, in the embedded (non-failover) driver the defines are unused.
> I'll do some additional cleanup in the used areas and followup with a
> scrubbing patch during our next code drop.
> 
> In the interim, James, please apply the ACKd patch.
> 

James,

I missed a stray qla_os.h include in one of the modules, as well as
some needed #includes to compile on additional platforms.
Compile-tested and run on x86 and ppc64.

Please apply on top of previous patch.

Thanks,
Andrew Vasquez

===== drivers/scsi/qla2xxx/ql2322.c 1.2 vs edited =====
--- 1.2/drivers/scsi/qla2xxx/ql2322.c	2004-03-12 09:06:10 -08:00
+++ edited/drivers/scsi/qla2xxx/ql2322.c	2004-06-22 15:17:29
-07:00
@@ -9,7 +9,6 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 
-#include "qla_os.h"
 #include "qla_def.h"
 
 static char qla_driver_name[] = "qla2322";
===== drivers/scsi/qla2xxx/qla_os.c 1.37 vs edited =====
--- 1.37/drivers/scsi/qla2xxx/qla_os.c	2004-06-22 15:16:38 -07:00
+++ edited/drivers/scsi/qla2xxx/qla_os.c	2004-06-22 15:17:45
-07:00
@@ -18,6 +18,7 @@
  */
 #include "qla_def.h"
 
+#include <linux/moduleparam.h>
 #include <linux/vmalloc.h>
 #include <linux/smp_lock.h>
 
