From: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: scsi_scan.c: quiet sparse noise
Date: Tue, 18 Jan 2011 13:28:28 -0700
Message-ID: <201101181328.28784.hartleys@visionengravers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail127.messagelabs.com ([216.82.250.115]:58569 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132Ab1ARU2v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Jan 2011 15:28:51 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de

Include header to quiet sparse noise about scsi_complete_async_scans
not being declared.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>

---

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 087821f..f1ef02b 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -43,6 +43,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_eh.h>
+#include <scsi/scsi_scan.h>
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
