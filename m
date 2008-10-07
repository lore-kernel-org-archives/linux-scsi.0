From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 09/12] ibmpex: Automatically load on IBM systems via DMI
Date: Mon, 06 Oct 2008 18:19:09 -0700
Message-ID: <20081007011909.12701.96969.stgit@elm3a70.beaverton.ibm.com>
References: <20081007011824.12701.39532.stgit@elm3a70.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:35160 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290AbYJGBTL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Oct 2008 21:19:11 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m971JBKM018536
	for <linux-scsi@vger.kernel.org>; Mon, 6 Oct 2008 21:19:11 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m971JBkV205796
	for <linux-scsi@vger.kernel.org>; Mon, 6 Oct 2008 19:19:11 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m971JA6Z025633
	for <linux-scsi@vger.kernel.org>; Mon, 6 Oct 2008 19:19:10 -0600
In-Reply-To: <20081007011824.12701.39532.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-scsi@vger.kernel.org>, lm-sensors <lm-sensors@lm-sensors.org>


Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/hwmon/ibmpex.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/ibmpex.c b/drivers/hwmon/ibmpex.c
index 4e9b19c..6e3a2c4 100644
--- a/drivers/hwmon/ibmpex.c
+++ b/drivers/hwmon/ibmpex.c
@@ -608,3 +608,9 @@ MODULE_LICENSE("GPL");
 
 module_init(ibmpex_init);
 module_exit(ibmpex_exit);
+
+MODULE_ALIAS("dmi:bvnIBM:*:pnIBMSystemx3650*");
+MODULE_ALIAS("dmi:bvnIBM:*:pnIBMSystemx3550*");
+MODULE_ALIAS("dmi:bvnIBM:*:pnIBMSystemx3655*");
+MODULE_ALIAS("dmi:bvnIBM:*:pnIBMSystemx3755*");
+MODULE_ALIAS("dmi:bvnIBM:*:pnIBMSystemx3350*");

