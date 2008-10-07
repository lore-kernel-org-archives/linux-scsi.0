From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 10/12] ibmaem: Automatically load on IBM systems via DMI
Date: Mon, 06 Oct 2008 18:19:14 -0700
Message-ID: <20081007011914.12701.7023.stgit@elm3a70.beaverton.ibm.com>
References: <20081007011824.12701.39532.stgit@elm3a70.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:58475 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754415AbYJGBTZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Oct 2008 21:19:25 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m971JOlK015140
	for <linux-scsi@vger.kernel.org>; Mon, 6 Oct 2008 21:19:24 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m971JGDc210512
	for <linux-scsi@vger.kernel.org>; Mon, 6 Oct 2008 21:19:16 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m971JF35023572
	for <linux-scsi@vger.kernel.org>; Mon, 6 Oct 2008 21:19:15 -0400
In-Reply-To: <20081007011824.12701.39532.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-scsi@vger.kernel.org>, lm-sensors <lm-sensors@lm-sensors.org>


Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/hwmon/ibmaem.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/ibmaem.c b/drivers/hwmon/ibmaem.c
index 0f70dc2..980145a 100644
--- a/drivers/hwmon/ibmaem.c
+++ b/drivers/hwmon/ibmaem.c
@@ -1118,3 +1118,10 @@ MODULE_LICENSE("GPL");
 
 module_init(aem_init);
 module_exit(aem_exit);
+
+MODULE_ALIAS("dmi:bvnIBM:*:pnIBMSystemx3650*");
+MODULE_ALIAS("dmi:bvnIBM:*:pnIBMSystemx3550*");
+MODULE_ALIAS("dmi:bvnIBM:*:pnIBMSystemx3655*");
+MODULE_ALIAS("dmi:bvnIBM:*:pnIBMSystemx3755*");
+MODULE_ALIAS("dmi:bvnIBM:*:pnIBMSystemx3350*");
+MODULE_ALIAS("dmi:bvnIBM:*:pnIBM3850M2/x3950M2*");

