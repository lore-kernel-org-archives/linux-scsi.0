From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 3/5] pmcraid: make pmcraid_minor static
Date: Sat, 16 Feb 2013 23:27:57 +0900
Message-ID: <1361024879-12934-3-git-send-email-akinobu.mita@gmail.com>
References: <1361024879-12934-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:55507 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab3BPO2a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Feb 2013 09:28:30 -0500
Received: by mail-pa0-f41.google.com with SMTP id fb11so2136325pad.14
        for <linux-scsi@vger.kernel.org>; Sat, 16 Feb 2013 06:28:30 -0800 (PST)
In-Reply-To: <1361024879-12934-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Anil Ravindranath <anil_ravindranath@pmc-sierra.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

The bitmap pmcraid_minor is only used in this file.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/pmcraid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index db77bf9..583ec82 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -76,7 +76,7 @@ static atomic_t pmcraid_adapter_count = ATOMIC_INIT(0);
  */
 static unsigned int pmcraid_major;
 static struct class *pmcraid_class;
-DECLARE_BITMAP(pmcraid_minor, PMCRAID_MAX_ADAPTERS);
+static DECLARE_BITMAP(pmcraid_minor, PMCRAID_MAX_ADAPTERS);
 
 /*
  * Module parameters
-- 
1.8.1

