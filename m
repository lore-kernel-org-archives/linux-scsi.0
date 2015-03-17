From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v3 41/42] hpsa: change driver version
Date: Tue, 17 Mar 2015 15:07:12 -0500
Message-ID: <20150317200712.19856.57811.stgit@brunhilda>
References: <20150317200139.19856.87982.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:36385 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932477AbbCQUIv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Mar 2015 16:08:51 -0400
Received: from g9t5009.houston.hp.com (g9t5009.houston.hp.com [15.240.92.67])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id 84E1E4B5F
	for <linux-scsi@vger.kernel.org>; Tue, 17 Mar 2015 20:08:51 +0000 (UTC)
In-Reply-To: <20150317200139.19856.87982.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

update driver version

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 96e1d02..893bb50 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -58,7 +58,7 @@
 #include "hpsa.h"
 
 /* HPSA_DRIVER_VERSION must be 3 byte values (0-255) separated by '.' */
-#define HPSA_DRIVER_VERSION "3.4.4-1"
+#define HPSA_DRIVER_VERSION "3.4.10-0"
 #define DRIVER_NAME "HP HPSA Driver (v " HPSA_DRIVER_VERSION ")"
 #define HPSA "hpsa"
 

