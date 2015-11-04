From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 27/27] hpsa: bump the driver version
Date: Wed, 04 Nov 2015 15:52:40 -0600
Message-ID: <20151104215240.15472.92049.stgit@brunhilda>
References: <20151104214910.15472.23179.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:33052 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030986AbbKDV4d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2015 16:56:33 -0500
In-Reply-To: <20151104214910.15472.23179.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Reviewed-by: Gerry Morong <gerry.morong.pmcs.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 5f02a60..57166e6 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -55,8 +55,11 @@
 #include "hpsa_cmd.h"
 #include "hpsa.h"
 
-/* HPSA_DRIVER_VERSION must be 3 byte values (0-255) separated by '.' */
-#define HPSA_DRIVER_VERSION "3.4.10-0"
+/*
+ * HPSA_DRIVER_VERSION must be 3 byte values (0-255) separated by '.'
+ * with an optional trailing '-' followed by a byte value (0-255).
+ */
+#define HPSA_DRIVER_VERSION "3.4.14-0"
 #define DRIVER_NAME "HP HPSA Driver (v " HPSA_DRIVER_VERSION ")"
 #define HPSA "hpsa"
 

