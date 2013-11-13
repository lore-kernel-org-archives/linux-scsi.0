From: Anand <anandkumar_santhanam@pmc-sierra.com>
Subject: [PATCH V2 1/4] pm80xx: Module author updation
Date: Wed, 13 Nov 2013 05:25:19 -0800
Message-ID: <52837DBF.9070008@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:50767 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751490Ab3KMNW3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Nov 2013 08:22:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, Sangeetha.Gnanasekaran@pmcs.com, Viswas.G@pmcs.com, Nikith.Ganigarakoppal@pmcs.com

>From b426c48789d95e1f3d45b9b2fc9813260caf5ee3 Mon Sep 17 00:00:00 2001
From: Nikith Ganigarakoppal <Nikith.Ganigarakoppal@pmcs.com>
Date: Wed, 13 Nov 2013 15:35:23 +0530
Subject: [PATCH V2 1/4] pm80xx: Module author updation.

Signed-off-by: Nikith.Ganigarakoppal@pmcs.com
Signed-off-by: Anandkumar.Santhanam@pmcs.com
Reviewed-by: Jack Wang <jinpu.wang@profitbricks.com>
---
 drivers/scsi/pm8001/pm8001_init.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 7b57fcd..17daaa4 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1170,6 +1170,7 @@ module_exit(pm8001_exit);
 MODULE_AUTHOR("Jack Wang <jack_wang@usish.com>");
 MODULE_AUTHOR("Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>");
 MODULE_AUTHOR("Sangeetha Gnanasekaran <Sangeetha.Gnanasekaran@pmcs.com>");
+MODULE_AUTHOR("Nikith Ganigarakoppal <Nikith.Ganigarakoppal@pmcs.com>");
 MODULE_DESCRIPTION(
 		"PMC-Sierra PM8001/8081/8088/8089/8074/8076/8077 "
 		"SAS/SATA controller driver");
-- 
1.7.1

