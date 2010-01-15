From: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: [PATCH] scsi_scan.c: quiet sparse noise
Date: Thu, 14 Jan 2010 17:47:32 -0700
Message-ID: <201001141747.32906.hartleys@visionengravers.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [206.15.93.42] ([206.15.93.42]:15422 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751156Ab0AOArb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Jan 2010 19:47:31 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de

scsi_scan.c: quiet sparse noise

Include the <scsi/scsi_scan.h> header to pick up the extern
prototype of scsi_complete_async_scans in order to quiet
the following sparse warning:

warning: symbol 'scsi_complete_async_scans' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>

---

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 012f73a..6e3ca0a 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -42,6 +42,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_eh.h>
+#include <scsi/scsi_scan.h>
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
