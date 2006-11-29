From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] drivers/scsi/scsi_error.c should #include "scsi_transport_api.h"
Date: Wed, 29 Nov 2006 11:04:22 +0100
Message-ID: <20061129100422.GL11084@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S966675AbWK2KEf@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Every file should #include the headers containing the prototypes for 
its global functions.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.19-rc6-mm2/drivers/scsi/scsi_error.c.old	2006-11-29 09:58:41.000000000 +0100
+++ linux-2.6.19-rc6-mm2/drivers/scsi/scsi_error.c	2006-11-29 09:58:58.000000000 +0100
@@ -36,6 +36,7 @@
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
+#include "scsi_transport_api.h"
 
 #define SENSE_TIMEOUT		(10*HZ)
 #define START_UNIT_TIMEOUT	(30*HZ)
