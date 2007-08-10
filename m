From: akpm@linux-foundation.org
Subject: [patch 15/30] drivers/scsi/scsi_error.c should #include "scsi_transport_api.h"
Date: Fri, 10 Aug 2007 14:50:42 -0700
Message-ID: <200708102150.l7ALohjk011360@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45914 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751408AbXHJV47 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Aug 2007 17:56:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, bunk@stusta.de

From: Adrian Bunk <bunk@stusta.de>

Every file should #include the headers containing the prototypes for its
global functions (in this case for scsi_schedule_eh()).

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_error.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/scsi/scsi_error.c~drivers-scsi-scsi_errorc-should-include drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c~drivers-scsi-scsi_errorc-should-include
+++ a/drivers/scsi/scsi_error.c
@@ -37,6 +37,7 @@
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
+#include "scsi_transport_api.h"
 
 #define SENSE_TIMEOUT		(10*HZ)
 
_
