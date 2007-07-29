From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] drivers/scsi/scsi_error.c should #include
	"scsi_transport_api.h"
Date: Sun, 29 Jul 2007 17:01:02 +0200
Message-ID: <20070729150102.GO16817@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47897 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765014AbXG2PBZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Jul 2007 11:01:25 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Every file should #include the headers containing the prototypes for
its global functions (in this case for scsi_schedule_eh()).

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.23-rc1-mm1/drivers/scsi/scsi_error.c.old	2007-07-28 17:10:48.000000000 +0200
+++ linux-2.6.23-rc1-mm1/drivers/scsi/scsi_error.c	2007-07-28 17:10:51.000000000 +0200
@@ -37,6 +37,7 @@
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
+#include "scsi_transport_api.h"
 
 #define SENSE_TIMEOUT		(10*HZ)
 

