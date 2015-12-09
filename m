From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 2/3] hpsa: change SAS transport devices to bus 0.
Date: Wed, 09 Dec 2015 15:18:51 -0600
Message-ID: <20151209211850.519.87076.stgit@brunhilda>
References: <20151209211816.519.50876.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:58989 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751410AbbLIVXR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2015 16:23:17 -0500
In-Reply-To: <20151209211816.519.50876.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Viswas.G@pmcs.com, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, Mahesh.Rajashekhara@pmcs.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com, james.bottomley@parallels.com
Cc: linux-scsi@vger.kernel.org

sas transport places devices on bus 0 but driver was setting
the bus to 3.

Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index ae5beda..fdd39fc 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -400,7 +400,7 @@ struct offline_device_entry {
 #define HPSA_PHYSICAL_DEVICE_BUS	0
 #define HPSA_RAID_VOLUME_BUS		1
 #define HPSA_EXTERNAL_RAID_VOLUME_BUS	2
-#define HPSA_HBA_BUS			3
+#define HPSA_HBA_BUS			0
 
 /*
 	Send the command to the hardware

